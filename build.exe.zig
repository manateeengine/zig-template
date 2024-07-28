const std = @import("std");

// TODO: Every instance of "zig-template" in this file should be renamed to match your project name
// TODO: Delete ./src/root.zig if you're building an application instead of a library
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zig-template",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe);

    switch (target.result.os.tag) {
        // OS-specific dependencies should be added here. Here's an example:
        // .windows => blk: {
        //     const foo = b.dependency("foo", .{});
        //     exe.addImport("foo", foo.module("foo"));
        //     break :blk;
        // },
        else => {},
    }

    const check_step = b.step("check", "Check compilation");
    const exe_check_only = b.addStaticLibrary(.{
        .name = "zig-template",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    check_step.dependOn(&exe_check_only.step);

    const test_step = b.step("test", "Run unit tests");
    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
    test_step.dependOn(&run_exe_unit_tests.step);

    const run_step = b.step("run", "Build and run the application");
    const run_cmd = b.addRunArtifact(exe);
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    run_cmd.step.dependOn(b.getInstallStep());
    run_step.dependOn(&run_cmd.step);
}
