const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .ReleaseSafe,
    });

    const raylib_dep = b.dependency("raylib_zig", .{
        .target = target,
        .optimize = optimize,
    });

    const raylib_artifact = raylib_dep.artifact("raylib");
    const raylib = raylib_dep.module("raylib");
    const raygui = raylib_dep.module("raygui");

    const accuracy = b.addModule("accuracy", .{
        .root_source_file = b.path("src/accuracy/_.zig"),
        .target = target,
        .optimize = optimize,
    });

    const arc = b.addModule("arc", .{
        .root_source_file = b.path("src/arc/_.zig"),
        .target = target,
        .optimize = optimize,
    });

    arc.addImport("raylib", raylib);
    arc.addImport("raygui", raygui);

    const note = b.addModule("note", .{
        .root_source_file = b.path("src/note/_.zig"),
        .target = target,
        .optimize = optimize,
    });

    note.addImport("raylib", raylib);
    note.addImport("raygui", raygui);

    const overlay = b.addModule("overlay", .{
        .root_source_file = b.path("src/overlay/_.zig"),
        .target = target,
        .optimize = optimize,
    });

    overlay.addImport("raylib", raylib);
    overlay.addImport("raygui", raygui);
    overlay.addImport("arc", arc);
    overlay.addImport("note", note);
    overlay.addImport("accuracy", accuracy);

    const exe = b.addExecutable(.{
        .name = "kau",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    exe.root_module.linkLibrary(raylib_artifact);
    exe.root_module.addImport("raylib", raylib);
    exe.root_module.addImport("raygui", raygui);
    exe.root_module.addImport("arc", arc);
    exe.root_module.addImport("note", note);
    exe.root_module.addImport("overlay", overlay);
    exe.root_module.addImport("accuracy", accuracy);

    b.installArtifact(exe);

    const resources = b.addInstallDirectory(.{
        .source_dir = b.path("resources"),
        .install_dir = .bin,
        .install_subdir = "resources",
    });

    b.getInstallStep().dependOn(&resources.step);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
}
