const std = @import("std");

const fs = std.fs;
const fmt = std.fmt;

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
fn addExes(b: *std.Build, run_all: *std.Build.Step) !void {
    const src_dir = try fs.cwd().openDir("src", .{ .iterate = true });

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    var it = src_dir.iterate();
    const check = b.step("check", "Check if it compiles");

    while (try it.next()) |entry| {
        switch (entry.kind) {
            .file => {
                const name = std.mem.trimRight(u8, entry.name, ".zig");
                const exe = b.addExecutable(.{
                    .name = name,
                    .root_module = b.createModule(.{
                        .root_source_file = b.path(
                            try fmt.allocPrint(b.allocator, "src/{s}.zig", .{name})
                        ),
                        .target = target,
                        .optimize = optimize,
                    }),
                });
                b.installArtifact(exe);

                check.dependOn(&exe.step);
                const run_cmd = b.addRunArtifact(exe);
                if (b.args) |args| {
                    run_cmd.addArgs(args);
                }

                const run_step = &run_cmd.step;
                b.step(
                    try fmt.allocPrint(b.allocator, "run-{s}", .{name}),
                    try fmt.allocPrint(b.allocator, "Run example {s}", .{name})
                ).dependOn(run_step);

                run_all.dependOn(run_step);
            },
            else => {},
        }
    }
}

pub fn build(b: *std.Build) !void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.

    const run_step = b.step("run-all", "Run the apps");
    try addExes(b, run_step);
}
