const std = @import("std");

const stdout = std.io.getStdOut().writer();
const linux = std.os.linux;
const posix = std.posix;
const process = std.process;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();
    const args = try process.argsAlloc(allocator);
    defer process.argsFree(allocator, args);

    if (args.len < 2) {
        try stdout.print("usage: {s} <command>\n", .{args[0]});
        return;
    }

    const pid = linux.fork();
    if (pid == 0) {
        // we are the child
        const env = [_:null]?[*:0]u8{null};
        const arg_len = args.len - 1;
        var args_ptrs: [1024:null]?[*:0]const u8 = undefined;
        for (args[1..], 0..) |arg, i| {
            args_ptrs[i] = arg;
        }
        args_ptrs[arg_len] = null;
        const err = posix.execvpeZ(args_ptrs[0].?, &args_ptrs, &env);
        try stdout.print("error={}\n", .{err});
        return;
    }

    const pid_i: i32 = @intCast(pid);
    const attach_rc = linux.ptrace(linux.PTRACE.ATTACH, pid_i, 0, 0, 0);
    try stdout.print("ptrace attach rc={d}...\n", .{attach_rc});

    var status: u32 = undefined;
    while (true) {
        const wait_rc = linux.waitpid(pid_i, &status, linux.W.NOHANG);
        if (wait_rc == pid) {
            // if ptraced, waitpid WNOHANG returns pid at once with stop status
            if (linux.W.IFEXITED(status)) {
                try stdout.print("child pid {} exited: {}\n", .{ pid, status });
                break;
            }
        }
        var result: i32 = 0;
        const ret = linux.ptrace(linux.PTRACE.PEEKUSER, pid_i, 8 * linux.REG.RAX, @intFromPtr(&result), 0);
        if (ret == 0) {
            std.log.info("Syscall number: i32 {d} u32 {d}, ret is {d}", .{ result, @as(u32, @bitCast(result)), ret });
        }
        _ = linux.ptrace(linux.PTRACE.SYSCALL, pid_i, 0, 0, 0);
    }
}
