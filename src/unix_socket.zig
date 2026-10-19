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
    var sockets: [2]linux.fd_t = undefined;
    // Datagram sockets preserve message boundaries, so one read gets one message.
    _ = try checked(linux.socketpair(linux.AF.UNIX, linux.SOCK.DGRAM | linux.SOCK.CLOEXEC, 0, &sockets));
    defer _ = linux.close(sockets[0]);
    defer _ = linux.close(sockets[1]);

    const message = "hello over a Unix domain socket";
    _ = try checked(linux.write(sockets[0], message, message.len));
    var buf: [128]u8 = undefined;
    const n = try checked(linux.read(sockets[1], &buf, buf.len));
    std.debug.print("Unix socket received: {s}\n", .{buf[0..n]});
}
