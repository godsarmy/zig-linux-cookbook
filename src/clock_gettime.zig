const std = @import("std");

const linux = std.os.linux;
const print = std.debug.print;

pub fn main() !void {
    var start_ts: linux.timespec = undefined;
    var end_ts: linux.timespec = undefined;
    // fetch timestamp in the beginning
    const start_rc = linux.clock_gettime(linux.CLOCK.MONOTONIC, &start_ts);
    // sleep 1 second
    std.Thread.sleep(1000000000);
    const end_rc = linux.clock_gettime(linux.CLOCK.MONOTONIC, &end_ts);
    print("start rc: {}, end rc: {}\n", .{ start_rc, end_rc });
    // print time diff
    const sec_diff = end_ts.sec - start_ts.sec;
    const nano_diff = end_ts.nsec - start_ts.nsec;
    print("elapsed time = {d} sec & {d} nanoseconds\n", .{ sec_diff, nano_diff });
}
