const std = @import("std");

const linux = std.os.linux;
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const pid = linux.fork();
    if (pid == 0) {
        // we are the child
        const mypid = linux.getpid();
        try stdout.print("I am printed by child...pid={}\n", .{mypid});
        std.process.exit(0);
    }
    var status: u32 = undefined;
    const rc = linux.waitpid(@intCast(pid), &status, 0);
    try stdout.print("I am printed by parent...status={}, rc={}\n", .{ status, rc });
    std.process.exit(0);
}
