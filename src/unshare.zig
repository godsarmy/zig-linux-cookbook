const std = @import("std");

const print = std.debug.print;
const linux = std.os.linux;

pub fn main() !void {
    const uid1 = linux.getuid();
    print("uid before ushare is {d}\n", .{uid1});

    // CLONE_NEWUSER is not defined in zig code
    const CLONE_NEWUSER = 0x10000000;
    const flags: usize = CLONE_NEWUSER;
    const rc = linux.unshare(flags);
    print("ushare rc: {d}\n", .{rc});

    const uid2 = linux.getuid();
    print("uid after ushare is {d}\n", .{uid2});
}
