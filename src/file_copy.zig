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

pub fn main() !void {
    // Exclusive directory creation keeps each run's files private.
    var path_buf: [128]u8 = undefined;
    const path = try std.fmt.bufPrintSentinel(&path_buf, "/tmp/zig-file-copy-{d}", .{linux.getpid()}, 0);
    _ = try checked(linux.mkdir(path, 0o700));
    defer _ = linux.rmdir(path);
    const dir: linux.fd_t = @intCast(try checked(linux.open(path, .{ .DIRECTORY = true, .CLOEXEC = true }, 0)));
    defer _ = linux.close(dir);
    const source: linux.fd_t = @intCast(try checked(linux.openat(dir, "source", .{ .ACCMODE = .RDWR, .CREAT = true, .EXCL = true, .CLOEXEC = true }, 0o600)));
    defer _ = linux.unlinkat(dir, "source", 0);
    defer _ = linux.close(source);
    const message = "Copy files with raw Linux syscalls.\n";
    try writeAll(source, message);
    _ = try checked(linux.lseek(source, 0, linux.SEEK.SET));
    const destination: linux.fd_t = @intCast(try checked(linux.openat(dir, "destination", .{ .ACCMODE = .WRONLY, .CREAT = true, .EXCL = true, .CLOEXEC = true }, 0o600)));
    defer _ = linux.unlinkat(dir, "destination", 0);
    defer _ = linux.close(destination);

    // A small buffer makes the copy take multiple reads. Zero means EOF.
    var buf: [16]u8 = undefined;
    var total: usize = 0;
    while (true) {
        const n = try readSome(source, &buf);
        if (n == 0) break;
        try writeAll(destination, buf[0..n]);
        total += n;
    }
    std.debug.print("Copied {d} bytes\n", .{total});
}
