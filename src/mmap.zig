const std = @import("std");

const print = std.debug.print;
const linux = std.os.linux;

pub fn main() !void {
    const open_rc = linux.open("/etc/passwd", linux.O{}, 0);
    if (linux.errno(open_rc) != .SUCCESS) {
        print("open failed: {}\n", .{linux.errno(open_rc)});
        return;
    }
    const fd: i32 = @intCast(open_rc);
    defer _ = linux.close(fd);

    var stat: linux.Statx = undefined;
    const stat_rc = linux.statx(linux.AT.FDCWD, "/etc/passwd", 0, .{ .SIZE = true }, &stat);
    if (linux.errno(stat_rc) != .SUCCESS) {
        print("statx failed: {}\n", .{linux.errno(stat_rc)});
        return;
    }

    const size: usize = @intCast(stat.size);
    print("file size {}\n", .{size});

    const mmap_rc = linux.mmap(null, size, .{ .READ = true }, .{ .TYPE = linux.MAP_TYPE.PRIVATE }, fd, 0);
    if (linux.errno(mmap_rc) != .SUCCESS) {
        print("mmap failed: {}\n", .{linux.errno(mmap_rc)});
        return;
    }
    print("mmap {}\n", .{mmap_rc});
    const buf: []u8 = @as([*]u8, @ptrFromInt(mmap_rc))[0..size];
    defer _ = linux.munmap(buf.ptr, size);

    var x: u32 = 0;
    while (x < size) : (x += 1) {
        print("{c}", .{buf[x]});
    }
}
