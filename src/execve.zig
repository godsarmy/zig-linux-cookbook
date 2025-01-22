const std = @import("std");

const stderr = std.io.getStdErr().writer();
const linux = std.os.linux;
const allocator = std.heap.page_allocator;

pub fn main() !void {
    var arena_allocator = std.heap.ArenaAllocator.init(allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    const cmd = "/usr/bin/ls";
    const argv = [_][]const u8{ "ls", "-l", "-a"};
    const envp = [_][]const u8{ "TERM=xterm"};

    const argv_buf = try arena.allocSentinel(?[*:0]const u8, argv.len, null);
    for (argv, 0..) |arg, i| argv_buf[i] = (try arena.dupeZ(u8, arg)).ptr;

    const envp_buf = try arena.allocSentinel(?[*:0]const u8, envp.len, null);
    for (envp, 0..) |env, i| envp_buf[i] = (try arena.dupeZ(u8, env)).ptr;

    const rc = linux.execve(cmd, argv_buf.ptr, envp_buf.ptr);
    if (rc != 0) {
        try stderr.print("execve failed: {d}\n", .{rc});
    }
}
