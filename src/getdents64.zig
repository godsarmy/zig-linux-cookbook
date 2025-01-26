const std = @import("std");

const mem = std.mem;
const stdout = std.io.getStdOut().writer();
const linux = std.os.linux;
const buf_size = 1024;

pub fn main() !void {
    const tmp_dir = "/tmp";
    var buf: [buf_size]u8 = undefined;

    const open_rc = linux.open(tmp_dir, linux.O{}, 0);
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
        while (index < nread) {
            const entry = @as(*align(1) linux.dirent64, @ptrCast(&buf[index]));
            const name = mem.sliceTo(@as([*:0]u8, @ptrCast(&entry.name)), 0);
            try stdout.print("{} {s}\n", .{ entry.ino, name });
            index += entry.reclen;
        }
        try stdout.print("total entries: {}\n", .{nread});
    }
}
