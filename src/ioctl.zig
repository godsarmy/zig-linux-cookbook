const std = @import("std");

const print = std.debug.print;
const linux = std.os.linux;

pub fn main() !void {
    const stdout_fd = linux.STDOUT_FILENO;
    var winsize: std.posix.winsize = undefined;

    const rc = linux.ioctl(stdout_fd, linux.T.IOCGWINSZ, @intFromPtr(&winsize));
    if (rc != 0) {
        const err = linux.E.init(rc);
        print("ioctl failed: {}\n", .{err});
        return;
    }

    print("Window size: rows={}, cols={}\n", .{ winsize.row, winsize.col });
}
