const std = @import("std");

const fs = std.fs;
const mem = std.mem;
const stdout = std.io.getStdOut().writer();
const linux = std.os.linux;
const buf_size = 1024;

pub fn main() !void {
    // read dir by getdents64
    const tmp_dir_path = "/tmp";
    var buf: [buf_size]u8 = undefined;

    const open_rc = linux.open(tmp_dir_path, linux.O{}, 0);
    const err = linux.E.init(open_rc);
    if (err != linux.E.SUCCESS) {
        try stdout.print("Error is {}\n", .{err});
    }
    defer _ = linux.close(@intCast(open_rc));

    while (true) {
        const nread = linux.getdents64(@intCast(open_rc), &buf, buf.len);
        if (nread == 0) {
            break;
        }
        var index: u32 = 0;
        try stdout.print("total read: {}\n", .{nread});
        while (index < nread) {
            const entry = @as(*align(1) linux.dirent64, @ptrCast(&buf[index]));
            const name = mem.sliceTo(@as([*:0]u8, @ptrCast(&entry.name)), 0);
            try stdout.print("{} {s}\n", .{ entry.ino, name });
            index += entry.reclen;
        }
    }

    // read dir in zig native way, much easier
    var tmp_dir = try fs.openDirAbsolute("/tmp", .{.iterate = true});
    defer tmp_dir.close();

    var iterate = tmp_dir.iterate();
    while (try iterate.next()) |entry| {
        try stdout.print("{s} ({})\n", .{ entry.name, entry.kind });
    }
}
