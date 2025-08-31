const std = @import("std");

const print = std.debug.print;
const linux = std.os.linux;

pub fn main() !void {
    var buf: [64]u8 = undefined;

    // call getrandom as linux system call to fetch random bytes
    const rc = linux.getrandom(&buf, buf.len, 0);
    print("rc: {}, buf is {s}\n", .{ rc, buf });
}
