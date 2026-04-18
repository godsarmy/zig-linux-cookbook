const std = @import("std");

const fmt = std.fmt;

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
fn addExes(b: *std.Build, run_all: *std.Build.Step) !void {
    var threaded: std.Io.Threaded = .init_single_threaded;
    const io = threaded.io();

    const src_dir = try std.Io.Dir.cwd().openDir(io, "src", .{ .iterate = true });
    defer src_dir.close(io);

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    var it = src_dir.iterate();
    const check = b.step("check", "Check if it compiles");

    while (try it.next(io)) |entry| {
        switch (entry.kind) {
            .file => {
                const name = std.Io.Dir.path.stem(entry.name);
                const exe = b.addExecutable(.{
                    .name = name,
                    .root_module = b.createModule(.{
                        .root_source_file = b.path(try fmt.allocPrint(b.allocator, "src/{s}.zig", .{name})),
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
                b.step(try fmt.allocPrint(b.allocator, "run-{s}", .{name}), try fmt.allocPrint(b.allocator, "Run example {s}", .{name})).dependOn(run_step);

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
