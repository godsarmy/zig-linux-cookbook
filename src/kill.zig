const std = @import("std");

const print = std.debug.print;
const linux = std.os.linux;

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    // standard zig native way to create subprocess
    const argv = [_][]const u8{ "sleep", "5" };
    var child = try std.process.spawn(io, .{ .argv = &argv });
    const child_pid = child.id.?;
    print("kill my is {}\n", .{child_pid});

    // call linux system call
    const rc = linux.kill(child_pid, linux.SIG.TERM);
    print("kill {}, rc: {d}\n", .{ child_pid, rc });

    _ = try child.wait(io);
}
