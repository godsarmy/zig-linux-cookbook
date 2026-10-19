const std = @import("std");
const linux = std.os.linux;

// Raw Linux calls return encoded errno values, not Zig error unions.
fn checked(rc: usize) !usize {
    const err = linux.errno(rc);
    if (err != .SUCCESS) {
        std.debug.print("syscall failed: {s}\n", .{@tagName(err)});
        return error.SyscallFailed;
    }
    return rc;
}

fn readSome(fd: linux.fd_t, buf: []u8) !usize {
    while (true) {
        const rc = linux.read(fd, buf.ptr, buf.len);
        if (linux.errno(rc) == .INTR) continue;
        return checked(rc);
    }
}

fn reap(pid: linux.pid_t) !u32 {
    var status: i32 = undefined;
    while (true) {
        const rc = linux.waitpid(pid, &status, 0);
        if (linux.errno(rc) == .INTR) continue;
        _ = try checked(rc);
        return @bitCast(status);
    }
}

pub fn main() !void {
    var pipe: [2]linux.fd_t = undefined;
    _ = try checked(linux.pipe2(&pipe, .{ .CLOEXEC = true }));
    defer _ = linux.close(pipe[0]);
    var writer_open = true;
    defer if (writer_open) {
        _ = linux.close(pipe[1]);
    };
    const fork_rc = try checked(linux.fork());
    if (fork_rc == 0) {
        _ = linux.close(pipe[0]);
        // dup2 makes descriptor 1 refer to the pipe and clears close-on-exec.
        if (pipe[1] != linux.STDOUT_FILENO) {
            if (linux.errno(linux.dup2(pipe[1], linux.STDOUT_FILENO)) != .SUCCESS) linux.exit_group(126);
            _ = linux.close(pipe[1]);
        } else {
            if (linux.errno(linux.fcntl(pipe[1], linux.F.SETFD, 0)) != .SUCCESS) linux.exit_group(126);
        }
        const argv = [_:null]?[*:0]const u8{ "echo", "captured child output" };
        const env = [_:null]?[*:0]const u8{};
        _ = linux.execve("/bin/echo", &argv, &env);
        // Only reached if exec failed. Exit directly without parent cleanup.
        linux.exit_group(127);
    }
    const pid: linux.pid_t = @intCast(fork_rc);
    var reaped = false;
    defer if (!reaped) {
        _ = linux.kill(pid, linux.SIG.KILL);
        _ = reap(pid) catch 0;
    };
    _ = try checked(linux.close(pipe[1]));
    writer_open = false;

    // Read until EOF: the child closes its stdout when it exits.
    var output: [256]u8 = undefined;
    while (true) {
        const n = try readSome(pipe[0], &output);
        if (n == 0) break;
        std.debug.print("{s}", .{output[0..n]});
    }
    const status = try reap(pid);
    reaped = true;
    if (!linux.W.IFEXITED(status) or linux.W.EXITSTATUS(status) != 0) return error.ChildFailed;
}
