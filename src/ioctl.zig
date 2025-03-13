const std = @import("std");

const stdout = std.io.getStdOut().writer();
const linux = std.os.linux;

pub fn main() !void {
    const stdout_fd = linux.STDOUT_FILENO;
    var winsize: std.posix.winsize = undefined;

    const rc = linux.ioctl(stdout_fd, linux.T.IOCGWINSZ, @intFromPtr(&winsize));
    if (rc != 0) {
        const err = linux.E.init(rc);
        try stdout.print("ioctl failed: {}\n", .{err});
        return;
    }

    try stdout.print("Window size: rows={}, cols={}\n", .{ winsize.row, winsize.col });
}
