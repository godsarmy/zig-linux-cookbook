const std = @import("std");

const stdout = std.io.getStdOut().writer();
const linux = std.os.linux;

pub fn main() !void {
    const uid1 = linux.getuid();
    try stdout.print("uid before ushare is {d}\n", .{uid1});

    // CLONE_NEWUSER is not defined in zig code
    const CLONE_NEWUSER = 0x10000000;
    const flags: usize = CLONE_NEWUSER;
    const rc = linux.unshare(flags);
    try stdout.print("ushare rc: {d}\n", .{rc});

    const uid2 = linux.getuid();
    try stdout.print("uid after ushare is {d}\n", .{uid2});
}
