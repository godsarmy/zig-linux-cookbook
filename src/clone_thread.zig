const std = @import("std");

const print = std.debug.print;
const linux = std.os.linux;

fn childFn(arg: usize) callconv(.c) u8 {
    _ = arg; // Unused argument in this simple example

    const tid = linux.gettid();
    // sleep 1 millisecond
    std.Thread.sleep(1_000_000);
    // For this simple example, we just print a message and exit.
    print("Child process run as {}\n", .{tid});

    return 0; // Exit code for the child process
}

pub fn main() !void {

    // Allocate a stack for the child process/thread.
    // Stack size should be sufficient for the child's operations.
    const stack_size: usize = 8 * 1024; // 8KB stack
    const stack_memory = try std.heap.page_allocator.alloc(u8, stack_size);
    defer std.heap.page_allocator.free(stack_memory);

    const stack_ptr = @intFromPtr(stack_memory.ptr + stack_size);
    const clone_flags = linux.CLONE.VM | linux.CLONE.THREAD | linux.CLONE.SIGHAND | linux.CLONE.FILES | linux.CLONE.FS;
    // You can also add other flags like CLONE_FS, CLONE_FILES, CLONE_SIGHAND, etc.
    // based on what resources you want to share.

    print("Parent process starting clone...\n", .{});

    // Call std.os.linux.clone to create the new process/thread
    const pid_or_err = linux.clone(
        childFn, // Function to execute in the child
        stack_ptr, // Stack pointer for the child
        clone_flags, // Clone flags
        0, // Argument passed to childFn (anyopaque)
        null, // Parent TID pointer (not used here, can be null)
        0, // New TLS value (0 for default)
        null, // Child TID pointer (not used here, can be null)
    );

    print("Clone call returned, child PID: {}\n", .{pid_or_err});
    if (pid_or_err <= 0) {
        print("child not created successfully\n", .{});
        return;
    }

    // sleep 2 millisecond
    std.Thread.sleep(2_000_000);
    // Wait for the child process to exit
    var status: u32 = undefined;
    const rc = linux.waitpid(@intCast(pid_or_err), &status, 0);
    print("Child process exited {}, with status: {}\n", .{ rc, status });
}
