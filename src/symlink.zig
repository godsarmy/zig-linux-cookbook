const std = @import("std");

const stdout = std.io.getStdOut().writer();
const linux = std.os.linux;

pub fn main() !void {

    const link_rc = linux.symlink("/tmp/foo", "/tmp/bar");
    try stdout.print("link returns {}\n", .{link_rc});

    var buf: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const readlink_rc = linux.readlink("/tmp/bar", &buf, buf.len);
    try stdout.print("readlink -> {s}\n", .{ buf[0..readlink_rc] });

    const unlink_rc = linux.unlink("/tmp/bar");
    try stdout.print("unlink returns {}\n", .{ unlink_rc });
}
