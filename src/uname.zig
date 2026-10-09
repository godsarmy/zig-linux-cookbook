const std = @import("std");

const mem = std.mem;
const linux = std.os.linux;
const print = std.debug.print;

pub fn main() !void {
    // demostrate to get a complex struct by linux call

    var uts: linux.utsname = undefined;

    const rc = linux.uname(&uts);
    print("rc of uname is {d}\n", .{rc});
    print("uts[{}] printed in raw mode {}\n", .{ @TypeOf(uts), uts });

    // iterate over fields of struct
    inline for (@typeInfo(@TypeOf(uts)).@"struct".field_names) |name| {
        print("{s}: {s}\n", .{ name, @field(uts, name) });
    }
}
