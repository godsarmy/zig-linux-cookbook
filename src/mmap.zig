const std = @import("std");

const mem = std.mem;
const print = std.debug.print;
const linux = std.os.linux;

pub fn main() !void {
    const open_rc = linux.open("/etc/passwd", linux.O{}, 0);
    const fd: i32 = @intCast(open_rc);
    defer _ = linux.close(fd);

    var stat: linux.Stat = undefined;
    const fstat_rc = linux.fstat(fd, &stat);
    if (fstat_rc != 0) {
        print("fstat failed\n", .{});
        return;
    }

    const size: usize = @intCast(stat.size);
    print("file size {}\n", .{size});

    const mmap_rc = linux.mmap(null, size, linux.PROT.READ, linux.MAP{ .TYPE = linux.MAP_TYPE.PRIVATE }, fd, 0);
    print("mmap {}\n", .{mmap_rc});
    const buf: []u8 = @as([*]u8, @ptrFromInt(mmap_rc))[0..size];
    defer _ = linux.munmap(@ptrCast(buf), size);

    var x: u32 = 0;
    while (x < size) : (x += 1) {
        print("{c}", .{buf[x]});
    }
}
