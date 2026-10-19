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
    var path_buf: [128]u8 = undefined;
    const path = try std.fmt.bufPrintSentinel(&path_buf, "/tmp/zig-inotify-{d}", .{linux.getpid()}, 0);
    _ = try checked(linux.mkdir(path, 0o700));
    defer _ = linux.rmdir(path);
    const dir: linux.fd_t = @intCast(try checked(linux.open(path, .{ .DIRECTORY = true, .CLOEXEC = true }, 0)));
    defer _ = linux.close(dir);

    const notify: linux.fd_t = @intCast(try checked(linux.inotify_init1(linux.IN.CLOEXEC)));
    defer _ = linux.close(notify); // Closing also removes the watch.
    _ = try checked(linux.inotify_add_watch(notify, path, linux.IN.CREATE));

    // Create our own file so no manual interaction is needed.
    const file: linux.fd_t = @intCast(try checked(linux.openat(dir, "watched.txt", .{ .ACCMODE = .WRONLY, .CREAT = true, .EXCL = true }, 0o600)));
    defer _ = linux.unlinkat(dir, "watched.txt", 0);
    defer _ = linux.close(file);

    var buf: [4096]u8 align(@alignOf(linux.inotify_event)) = undefined;
    const n = try checked(linux.read(notify, &buf, buf.len));
    if (n < @sizeOf(linux.inotify_event)) return error.MissingEvent;
    // Only one file was created, so we expect one creation event.
    const event: *const linux.inotify_event = @ptrCast(&buf);
    if (event.mask & linux.IN.CREATE == 0) return error.UnexpectedEvent;
    std.debug.print("inotify: created {s}\n", .{event.getName() orelse return error.MissingName});
}
