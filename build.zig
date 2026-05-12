const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .ReleaseSmall,
    });

    const raylib_dep = b.dependency("raylib_zig", .{
        .target = target,
        .optimize = optimize,
    });

    const raylib_artifact = raylib_dep.artifact("raylib");
    const raylib = raylib_dep.module("raylib");
    const raygui = raylib_dep.module("raygui");

    const constants = b.addModule("constants", .{
        .root_source_file = b.path("src/constants/_.zig"),
        .target = target,
        .optimize = optimize,
    });

    const types = b.addModule("types", .{
        .root_source_file = b.path("src/types/_.zig"),
        .target = target,
        .optimize = optimize,
    });

    types.addImport("raylib", raylib);
    types.addImport("raygui", raygui);

    const settings = b.addModule("settings", .{
        .root_source_file = b.path("src/settings/_.zig"),
        .target = target,
        .optimize = optimize,
    });

    settings.addImport("raylib", raylib);
    settings.addImport("raygui", raygui);
    settings.addImport("types", types);
    settings.addImport("constants", constants);

    const scores = b.addModule("scores", .{
        .root_source_file = b.path("src/scores/_.zig"),
        .target = target,
        .optimize = optimize,
    });

    const effect = b.addModule("effect", .{
        .root_source_file = b.path("src/effect/_.zig"),
        .target = target,
        .optimize = optimize,
    });

    effect.addImport("raylib", raylib);
    effect.addImport("raygui", raygui);
    effect.addImport("types", types);

    const note = b.addModule("note", .{
        .root_source_file = b.path("src/note/_.zig"),
        .target = target,
        .optimize = optimize,
    });

    note.addImport("raylib", raylib);
    note.addImport("raygui", raygui);
    note.addImport("types", types);
    note.addImport("scores", scores);
    note.addImport("effect", effect);

    const overlay = b.addModule("overlay", .{
        .root_source_file = b.path("src/overlay/_.zig"),
        .target = target,
        .optimize = optimize,
    });

    overlay.addImport("raylib", raylib);
    overlay.addImport("raygui", raygui);
    overlay.addImport("note", note);
    overlay.addImport("types", types);
    overlay.addImport("scores", scores);
    overlay.addImport("effect", effect);
    overlay.addImport("settings", settings);

    const exe = b.addExecutable(.{
        .name = "kau",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .strip = true,
        }),
    });

    exe.root_module.linkLibrary(raylib_artifact);
    exe.root_module.addImport("raylib", raylib);
    exe.root_module.addImport("raygui", raygui);
    exe.root_module.addImport("note", note);
    exe.root_module.addImport("types", types);
    exe.root_module.addImport("scores", scores);
    exe.root_module.addImport("overlay", overlay);
    exe.root_module.addImport("settings", settings);
    exe.root_module.addImport("constants", constants);

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
