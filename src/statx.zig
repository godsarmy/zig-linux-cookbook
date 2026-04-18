const std = @import("std");

const print = std.debug.print;
const linux = std.os.linux;

fn statx_type(path: [:0]const u8) !void {
    var statbuf: linux.Statx = undefined;
    const rc = linux.statx(linux.AT.FDCWD, path, linux.AT.SYMLINK_NOFOLLOW, .{ .TYPE = true }, &statbuf);

    if (linux.errno(rc) != .SUCCESS) {
        print("Error to call statx on {s}: {}\n", .{ path, linux.errno(rc) });
        return;
    }

    if (linux.S.ISDIR(statbuf.mode)) {
        print("{s} is directory\n", .{path});
    } else if (linux.S.ISREG(statbuf.mode)) {
        print("{s} is regular file\n", .{path});
    } else if (linux.S.ISLNK(statbuf.mode)) {
        print("{s} is symlink\n", .{path});
    } else if (linux.S.ISBLK(statbuf.mode)) {
        print("{s} is block device\n", .{path});
    } else if (linux.S.ISCHR(statbuf.mode)) {
        print("{s} is character device\n", .{path});
    } else if (linux.S.ISFIFO(statbuf.mode)) {
        print("{s} is fifo\n", .{path});
    } else if (linux.S.ISSOCK(statbuf.mode)) {
        print("{s} is uds\n", .{path});
    } else {
        print("unknow type of {s}\n", .{path});
    }
}

pub fn main() !void {
    try statx_type("/etc");
    try statx_type("/etc/passwd");
    try statx_type("/dev/null");
    try statx_type("/dev/loop0");
    try statx_type("/dev/core");
    try statx_type("/no/such/file");
}
