const std = @import("std");

// Zig Version: 0.11.0-dev.3798+a5e15eced
// Zig Build Command: zig build
// Zig Run Command: zig build -h
//     zig build run_test0_zig
//     zig build run_test1_zig
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // tests_zig
    const tests_zig = .{
        "test0",
        "test1",
    };
    inline for (tests_zig) |name| {
        const exe = b.addExecutable(.{
            .name = name,
            .root_source_file = .{ .path = std.fmt.comptimePrint("tests/{s}.zig", .{name}) },
            .target = target,
            .optimize = optimize,
        });
        exe.addIncludePath("./thirdparty/ggml/include");
        exe.addIncludePath("./thirdparty/ggml/include/ggml");
        exe.addCSourceFiles(&.{
            "./thirdparty/ggml/src/ggml.c",
        }, &.{"-std=c11"});
        exe.linkLibC();
        b.installArtifact(exe);
        const run_cmd = b.addRunArtifact(exe);
        run_cmd.step.dependOn(b.getInstallStep());
        if (b.args) |args| run_cmd.addArgs(args);
        const run_step = b.step("run_" ++ name ++ "_zig", "Run tests_zig");
        run_step.dependOn(&run_cmd.step);
    }
}

