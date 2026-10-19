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

fn readSome(fd: linux.fd_t, buf: []u8) !usize {
    while (true) {
        const rc = linux.read(fd, buf.ptr, buf.len);
        if (linux.errno(rc) == .INTR) continue;
        return checked(rc);
    }
}

fn writeAll(fd: linux.fd_t, bytes: []const u8) !void {
    var offset: usize = 0;
    while (offset < bytes.len) {
        const rc = linux.write(fd, bytes[offset..].ptr, bytes.len - offset);
        if (linux.errno(rc) == .INTR) continue;
        const n = try checked(rc);
        if (n == 0) return error.NoProgress;
        offset += n;
    }
}

fn receive(fd: linux.fd_t, bytes: []u8) !void {
    var offset: usize = 0;
    while (offset < bytes.len) {
        const n = try readSome(fd, bytes[offset..]);
        if (n == 0) return error.UnexpectedEof;
        offset += n;
    }
}

pub fn main() !void {
    const listener: linux.fd_t = @intCast(try checked(linux.socket(linux.AF.INET, linux.SOCK.STREAM | linux.SOCK.CLOEXEC, 0)));
    defer _ = linux.close(listener);
    // Port zero asks the kernel to allocate a free port on 127.0.0.1.
    var address: linux.sockaddr.in = .{
        .port = 0,
        .addr = std.mem.nativeToBig(u32, 0x7f000001),
    };
    _ = try checked(linux.bind(listener, @ptrCast(&address), @sizeOf(@TypeOf(address))));
    _ = try checked(linux.listen(listener, 1));
    var address_len: linux.socklen_t = @sizeOf(@TypeOf(address));
    _ = try checked(linux.getsockname(listener, @ptrCast(&address), &address_len));

    const client: linux.fd_t = @intCast(try checked(linux.socket(linux.AF.INET, linux.SOCK.STREAM | linux.SOCK.CLOEXEC, 0)));
    defer _ = linux.close(client);
    _ = try checked(linux.connect(client, &address, address_len));
    const server: linux.fd_t = @intCast(try checked(linux.accept4(listener, null, null, linux.SOCK.CLOEXEC)));
    defer _ = linux.close(server);

    // One small exchange lets both endpoints run in this process.
    const message = "hello over TCP";
    try writeAll(client, message);
    var request: [message.len]u8 = undefined;
    try receive(server, &request);
    try writeAll(server, &request);
    var reply: [message.len]u8 = undefined;
    try receive(client, &reply);
    std.debug.print("TCP echo on 127.0.0.1:{d}: {s}\n", .{ std.mem.bigToNative(u16, address.port), reply });
}
