const std = @import("std");

// TODO: Every instance of "zig-template" in this file should be renamed to match your project name
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zig_template = b.dependency("template", .{});

    const some_example_exe = b.addExecutable(.{
        .name = "examples",
        .root_source_file = b.path("src/some_example.zig"),
        .target = target,
        .optimize = optimize,
    });
    some_example_exe.root_module.addImport("template", zig_template.module("zig-template"));
    b.installArtifact(some_example_exe);
    const some_example_run_step = b.step("run", "Build and run example: some example");
    const some_example_run_cmd = b.addRunArtifact(some_example_exe);
    if (b.args) |args| {
        some_example_run_cmd.addArgs(args);
    }
    some_example_run_cmd.step.dependOn(b.getInstallStep());
    some_example_run_step.dependOn(&some_example_run_cmd.step);
}
