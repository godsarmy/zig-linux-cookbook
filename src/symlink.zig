const std = @import("std");

const print = std.debug.print;
const linux = std.os.linux;

pub fn main() !void {
    const link_rc = linux.symlink("/tmp/foo", "/tmp/bar");
    print("link returns {}\n", .{link_rc});

    var buf: [std.fs.max_path_bytes]u8 = undefined;
    const readlink_rc = linux.readlink("/tmp/bar", &buf, buf.len);
    print("readlink -> {s}\n", .{buf[0..readlink_rc]});

    const unlink_rc = linux.unlink("/tmp/bar");
    print("unlink returns {}\n", .{unlink_rc});
}
