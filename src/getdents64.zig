const std = @import("std");

const mem = std.mem;
const print = std.debug.print;
const linux = std.os.linux;
const buf_size = 1024;

pub fn main() !void {
    // read dir by getdents64
    const tmp_dir_path = "/tmp";
    var buf: [buf_size]u8 = undefined;

    const open_rc = linux.open(tmp_dir_path, linux.O{}, 0);
    const err = linux.errno(open_rc);
    if (err != linux.E.SUCCESS) {
        print("Error is {}\n", .{err});
        return;
    }
    defer _ = linux.close(@intCast(open_rc));

    while (true) {
        const nread = linux.getdents64(@intCast(open_rc), &buf, buf.len);
        if (nread == 0) {
            break;
        }
        var index: u32 = 0;
        print("total read: {}\n", .{nread});
        while (index < nread) {
            const entry = @as(*align(1) linux.dirent64, @ptrCast(&buf[index]));
            const name = mem.sliceTo(@as([*:0]u8, @ptrCast(&entry.name)), 0);
            print("{} {s}\n", .{ entry.ino, name });
            index += entry.reclen;
        }
    }

    // read dir in zig native way, much easier
    var threaded: std.Io.Threaded = .init_single_threaded;
    const io = threaded.io();

    const tmp_dir = try std.Io.Dir.openDirAbsolute(io, "/tmp", .{ .iterate = true });
    defer tmp_dir.close(io);

    var iterate = tmp_dir.iterate();
    while (try iterate.next(io)) |entry| {
        print("{s} ({})\n", .{ entry.name, entry.kind });
    }
}
