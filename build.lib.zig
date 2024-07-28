const std = @import("std");

// TODO: Every instance of "zig-template" in this file should be renamed to match your project name
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const module = b.addModule("zig-template", .{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    switch (target.result.os.tag) {
        // OS-specific dependencies should be added here. Here's an example:
        // .windows => blk: {
        //     const foo = b.dependency("foo", .{});
        //     module.addImport("foo", foo.module("foo"));
        //     break :blk;
        // },
        else => {},
    }

    const lib = b.addStaticLibrary(.{
        .name = "zig-template",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    lib.root_module.addImport("zig-template", module);
    b.installArtifact(lib);

    const check_step = b.step("check", "Check compilation");
    const lib_check_only = b.addStaticLibrary(.{
        .name = "zig-template",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    lib_check_only.root_module.addImport("zig-template", module);
    check_step.dependOn(&lib_check_only.step);

    const test_step = b.step("test", "Run unit tests");
    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    test_step.dependOn(&run_lib_unit_tests.step);

    const docs_step = b.step("docs", "Generate lib documentation");
    const install_docs = b.addInstallDirectory(.{
        .source_dir = lib.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });
    docs_step.dependOn(&install_docs.step);
}
