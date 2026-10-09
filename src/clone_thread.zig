const std = @import("std");

const print = std.debug.print;
const linux = std.os.linux;

fn childFn(arg: usize) callconv(.c) u8 {
    _ = arg; // Unused argument in this simple example

    const tid = linux.gettid();
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
    const clone_flags = linux.CLONE.VM | linux.CLONE.THREAD | linux.CLONE.SIGHAND |
        linux.CLONE.FILES | linux.CLONE.FS | linux.CLONE.PARENT_SETTID | linux.CLONE.CHILD_CLEARTID;
    // The kernel stores the TID before clone returns, then clears it on thread exit.
    var child_tid: linux.pid_t align(4) = 0;

    print("Parent process starting clone...\n", .{});

    // Call std.os.linux.clone to create the new process/thread
    const pid_or_err = linux.clone(
        childFn, // Function to execute in the child
        stack_ptr, // Stack pointer for the child
        clone_flags, // Clone flags
        0, // Argument passed to childFn (anyopaque)
        &child_tid, // Store the child's TID in shared memory
        0, // New TLS value (0 for default)
        &child_tid, // Clear the TID and wake futex waiters on exit
    );

    const clone_errno = linux.errno(pid_or_err);
    if (clone_errno != .SUCCESS) {
        print("clone failed: {s}\n", .{@tagName(clone_errno)});
        return error.CloneFailed;
    }
    print("Clone call returned, child TID: {}\n", .{pid_or_err});

    // CLONE.THREAD threads cannot be joined with waitpid. Wait for the kernel
    // to clear the TID before freeing the child's stack.
    while (true) {
        const tid = @atomicLoad(linux.pid_t, &child_tid, .acquire);
        if (tid == 0) break;

        // The kernel's exit wake uses a shared futex, so private must be false.
        const rc = linux.futex_4arg(&child_tid, .{ .cmd = .WAIT, .private = false }, @bitCast(tid), null);
        switch (linux.errno(rc)) {
            .SUCCESS, .INTR, .AGAIN => continue,
            else => |err| {
                print("futex wait failed: {s}\n", .{@tagName(err)});
                // Terminate all threads without freeing a potentially active stack.
                std.process.exit(1);
            },
        }
    }
    print("Child thread {} exited\n", .{pid_or_err});
}
