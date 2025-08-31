const std = @import("std");

const mem = std.mem;
const meta = std.meta;
const linux = std.os.linux;
const print = std.debug.print;

pub fn main() !void {
    // demostrate to get a complex struct by linux call

    var uts: linux.utsname = undefined;

    const rc = linux.uname(&uts);
    print("rc of uname is {d}\n", .{rc});
    print("uts[{}] printed in raw mode {}\n", .{ @TypeOf(uts), uts });

    // iterate over fields of struct
    inline for (meta.fields(@TypeOf(uts))) |f| {
        print("{s}: {s}\n", .{ f.name, @as(f.type, @field(uts, f.name)) });
    }
}
