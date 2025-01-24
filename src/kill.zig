const std = @import("std");

const stdout = std.io.getStdOut().writer();
const linux = std.os.linux;
const ChildProcess = std.process.Child;

pub fn main() !void {

    // standard zig native way to create subprocess
    const argv = [_][]const u8{ "sleep", "5" };
    var child = ChildProcess.init(&argv, std.heap.page_allocator);
    _ = try child.spawn();
    try stdout.print("kill my is {}\n", .{child.id});

    // call linux system call
    const rc = linux.kill(child.id, linux.SIG.TERM);
    try stdout.print("kill {}, rc: {d}\n", .{ child.id, rc });
}
