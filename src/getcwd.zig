const std = @import("std");

const mem = std.mem;
const stdout = std.io.getStdOut().writer();
const linux = std.os.linux;

pub fn main() !void {
    const tmp = "/tmp";
    const rc = linux.chdir(tmp);
    try stdout.print("chdir rc: {d}\n", .{rc});

    var buf: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    // call getcwd as linux system call
    _ = linux.getcwd(&buf, buf.len);
    const ptr = mem.sliceTo(&buf, 0);
    try stdout.print("CWD is {s}\n", .{ptr});

    // call getcwd in zig native func
    const cwd = try std.process.getCwd(&buf);
    try stdout.print("CWD is {s}\n", .{cwd});
}
