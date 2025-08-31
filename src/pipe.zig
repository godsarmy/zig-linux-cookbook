const std = @import("std");

const linux = std.os.linux;
const print = std.debug.print;

pub fn main() !void {
    // Show usage of pipe, read, write

    var pipefd: [2]linux.fd_t = undefined;
    const pipe_rc = linux.pipe(&pipefd);
    if (pipe_rc != 0) {
        print("pipe failed: {}\n", .{pipe_rc});
        return;
    }

    const pid = linux.fork();
    if (pid == 0) {
        // we are the child
        _ = linux.close(pipefd[1]);
        var buf: [1]u8 = undefined;
        print("read in child: ", .{});
        while (linux.read(pipefd[0], &buf, buf.len) > 0)
            print("{s}", .{buf});

        print("\n", .{});
        _ = linux.close(pipefd[0]);

        std.process.exit(0);
    }
    _ = linux.close(pipefd[0]);
    const write_rc = linux.write(pipefd[1], "hello world", 11);
    _ = linux.close(pipefd[1]);

    var status: u32 = undefined;
    _ = linux.waitpid(@intCast(pid), &status, 0);

    print("write rc in parent: {}\n", .{write_rc});
}
