const std = @import("std");

const stdout = std.io.getStdOut().writer();
const linux = std.os.linux;

pub fn main() !void {
    const gid = linux.getgid();

    var gids: [1024]linux.gid_t = undefined;
    const rc = linux.getgroups(gids.len, &gids[0]);

    try stdout.print("pid is {}, {} pids are {any}\n", .{ gid, rc, gids[0..rc] });
}
