const std = @import("std");
const linux = std.os.linux;

// Raw Linux calls return encoded errno values, not Zig error unions.
fn checked(rc: usize) !usize {
    const err = linux.errno(rc);
    if (err != .SUCCESS) {
        std.debug.print("syscall failed: {s}\n", .{@tagName(err)});
        return error.SyscallFailed;
    }
    return rc;
}

pub fn main() !void {
    const timer: linux.fd_t = @intCast(try checked(linux.timerfd_create(.MONOTONIC, .{ .CLOEXEC = true })));
    defer _ = linux.close(timer);
    const period: linux.timespec = .{ .sec = 0, .nsec = 25_000_000 };
    const schedule: linux.itimerspec = .{ .it_interval = period, .it_value = period };
    _ = try checked(linux.timerfd_settime(timer, .{}, &schedule, null));

    var ticks: u64 = 0;
    while (ticks < 3) {
        // Each read returns a native-endian u64 count, possibly several ticks.
        var expirations: u64 = 0;
        const read_rc = linux.read(timer, std.mem.asBytes(&expirations).ptr, @sizeOf(u64));
        if (linux.errno(read_rc) == .INTR) continue;
        if (try checked(read_rc) != @sizeOf(u64) or expirations == 0) return error.InvalidTimerRead;
        ticks += expirations;
        std.debug.print("timerfd: {d} expiration(s), total={d}\n", .{ expirations, ticks });
    }
    // Closing the descriptor stops the timer.
    std.debug.print("Timer finished\n", .{});
}
