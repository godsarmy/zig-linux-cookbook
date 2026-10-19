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
    const epoll: linux.fd_t = @intCast(try checked(linux.epoll_create1(linux.EPOLL.CLOEXEC)));
    defer _ = linux.close(epoll);

    // Register the pipe's read end. The default is level-triggered readiness.
    var interest: linux.epoll_event = .{ .events = linux.EPOLL.IN, .data = .{ .fd = pipe[0] } };
    _ = try checked(linux.epoll_ctl(epoll, linux.EPOLL.CTL_ADD, pipe[0], &interest));
    _ = try checked(linux.write(pipe[1], "x", 1));

    var events: [1]linux.epoll_event = undefined;
    if (try checked(linux.epoll_wait(epoll, &events, events.len, 1000)) == 0) return error.Timeout;
    if (events[0].events & linux.EPOLL.IN == 0) return error.NotReadable;
    var buf: [1]u8 = undefined;
    const n = try checked(linux.read(events[0].data.fd, &buf, buf.len));
    std.debug.print("epoll: pipe is readable: {s}\n", .{buf[0..n]});
}
