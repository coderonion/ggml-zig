const std = @import("std");

// Zig Version: 0.11.0-dev.3798+a5e15eced
// Zig Build Command: zig build
// Zig Run Command: zig build -h
//     zig build run_zig_test0
//     zig build run_zig_test1
//     zig build run_zig_test2
//     zig build run_zig_test3
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});
    // const optimize = .ReleaseFast;
    // const optimize = .ReleaseSmall;

    // zig_examples
    const zig_examples = .{

    };
    inline for (zig_examples) |name| {
        const exe = b.addExecutable(.{
            .name = name,
            .root_source_file = .{ .path = std.fmt.comptimePrint("examples/{s}/main.zig", .{name}) },
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
        // This allows the user to pass arguments to the application in the build
        // command itself, like this: `zig build run -- arg1 arg2 etc`
        run_cmd.step.dependOn(b.getInstallStep());
        if (b.args) |args| run_cmd.addArgs(args);
        const run_step = b.step("run_zig_" ++ name, "Run zig_examples");
        run_step.dependOn(&run_cmd.step);
    }

    // zig_tests
    const zig_tests = .{
        "test0",
        "test1",
        "test2",
        "test3",
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
        // This allows the user to pass arguments to the application in the build
        // command itself, like this: `zig build run -- arg1 arg2 etc`
        run_cmd.step.dependOn(b.getInstallStep());
        if (b.args) |args| run_cmd.addArgs(args);
        const run_step = b.step("run_zig_" ++ name, "Run zig_tests");
        run_step.dependOn(&run_cmd.step);
    }
}

