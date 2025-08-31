const std = @import("std");

const print = std.debug.print;
const linux = std.os.linux;

pub fn main() !void {
    const mypid = linux.getpid();
    const linux_capability_version_3 = 0x20080522;

    var hdr = linux.cap_user_header_t{ .pid = @intCast(mypid), .version = linux_capability_version_3 };
    var data: linux.cap_user_data_t = undefined;
    const rc = linux.capget(&hdr, &data);

    print("rc: {d}, hdr: {}, cap data: {}\n", .{ rc, hdr, data });
}
