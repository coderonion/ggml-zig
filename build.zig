const std = @import("std");

// Zig Version: 0.11.0-dev.3798+a5e15eced
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zig_tests = .{
        "test0",
    };
    inline for (zig_tests) |name| {
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
        const run_step = b.step("test_" ++ name, "Run tests");
        run_step.dependOn(&run_cmd.step);
    }
}

