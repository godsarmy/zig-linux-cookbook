const std = @import("std");

const print = std.debug.print;
const linux = std.os.linux;

pub fn main() !void {
    const gid = linux.getgid();

    var gids: [1024]linux.gid_t = undefined;
    const rc = linux.getgroups(gids.len, gids[0..].ptr);
    if (linux.errno(rc) != .SUCCESS) {
        print("getgroups failed: {}\n", .{linux.errno(rc)});
        return;
    }

    const count: usize = @intCast(rc);
    print("pid is {}, {} pids are {any}\n", .{ gid, count, gids[0..count] });
}
