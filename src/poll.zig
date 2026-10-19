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
    var pipe: [2]linux.fd_t = undefined;
    _ = try checked(linux.pipe2(&pipe, .{ .CLOEXEC = true }));
    defer _ = linux.close(pipe[0]);
    defer _ = linux.close(pipe[1]);

    // Put one byte in the pipe so poll can report it as readable.
    _ = try checked(linux.write(pipe[1], "x", 1));
    var fds = [_]linux.pollfd{.{ .fd = pipe[0], .events = linux.POLL.IN }};
    if (try checked(linux.poll(&fds, fds.len, 1000)) == 0) return error.Timeout;
    if (fds[0].revents & linux.POLL.IN == 0) return error.NotReadable;

    var buf: [1]u8 = undefined;
    const n = try checked(linux.read(pipe[0], &buf, buf.len));
    std.debug.print("poll: pipe is readable: {s}\n", .{buf[0..n]});
}
