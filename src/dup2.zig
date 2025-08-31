const std = @import("std");

const linux = std.os.linux;
const print = std.debug.print;

pub fn main() !void {
    // redict stdout to stderr
    _ = linux.dup2(2, 1);
    // this will write to stderr instead
    print("I am printed in stderr\n", .{});
}
