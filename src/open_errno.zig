const std = @import("std");

const stdout = std.io.getStdOut().writer();
const linux = std.os.linux;

pub fn main() !void {
    // call system open with non existing file
    const err_rc = linux.open("no/such/file", linux.O{}, 0);
    // fetch err from error code, it is NOENT
    const err = linux.E.init(err_rc);
    try stdout.print("Error is {}\n", .{err});

    const open_rc = linux.open("/etc/passwd", linux.O{}, 0);
    const close_rc = linux.close(@intCast(open_rc));
    try stdout.print("open/close rc is {}/{}\n", .{ open_rc, close_rc });
    // fetch err from error code, it is SUCCESS
    const err2 = linux.E.init(open_rc);
    try stdout.print("Error is {}\n", .{err2});
}
