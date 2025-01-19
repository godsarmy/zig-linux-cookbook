const std = @import("std");

const debug = std.debug;
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdOut().writer();
const linux = std.os.linux;

fn lstat_type(path: [:0]const u8) !void {
    var statbuf: linux.Stat = undefined;
    const rc = linux.lstat(path, &statbuf);

    if (rc != 0) {
        try stdout.print("Error to call lstat on {s}: {d}\n", .{path, rc});
        return;
    }

    if (linux.S.ISDIR(statbuf.mode)) {
        try stdout.print("{s} is directory\n", .{path});
    } else if (linux.S.ISREG(statbuf.mode)) {
        try stdout.print("{s} is regular file\n", .{path});
    } else if (linux.S.ISLNK(statbuf.mode)) {
        try stdout.print("{s} is symlink\n", .{path});
    } else if (linux.S.ISBLK(statbuf.mode)) {
        try stdout.print("{s} is block device\n", .{path});
    } else if (linux.S.ISCHR(statbuf.mode)) {
        try stdout.print("{s} is character device\n", .{path});
    } else if (linux.S.ISFIFO(statbuf.mode)) {
        try stdout.print("{s} is fifo\n", .{path});
    } else if (linux.S.ISSOCK(statbuf.mode)) {
        try stdout.print("{s} is uds\n", .{path});
    } else {
        try stdout.print("unknow type of {s}\n", .{path});
    }
}

pub fn main() !void {
    try lstat_type("/etc");
    try lstat_type("/etc/passwd");
    try lstat_type("/dev/null");
    try lstat_type("/dev/loop0");
    try lstat_type("/dev/core");
    try lstat_type("/no/such/file");
}
