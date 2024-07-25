const std = @import("std");
const fs = std.fs;
const Allocator = std.mem.Allocator;
const types = @import("../types/types.zig");

pub const Utility = struct {
    const Self = @This();

    allocator: Allocator,
    parsed: std.json.Parsed([]types.ARson),

    pub fn init(allocator: Allocator) Self {
        return Self{ .allocator = allocator, .parsed = undefined };
    }

    pub fn deinit(self: *Self) void {
        defer self.parsed.deinit();
    }

    pub fn get_arr_son(self: *Self) ![]types.ARson {
        const file = try fs.cwd().readFileAlloc(self.allocator, "data/adaption_rate.json", 15 * 1024 * 1024);
        defer self.allocator.free(file);
        self.parsed = try std.json.parseFromSlice([]types.ARson, self.allocator, file, .{ .allocate = .alloc_always, .ignore_unknown_fields = true });
        return self.parsed.value;
    }
};
