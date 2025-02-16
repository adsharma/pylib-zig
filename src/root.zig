//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const testing = std.testing;

pub const AutoMap = struct {
    map: std.AutoHashMap(u64, u64), // Example: Key and Value are both u64
    allocator: std.mem.Allocator,

    pub fn init(allocator: ?std.mem.Allocator) !AutoMap {
        const alloc = allocator orelse std.heap.page_allocator;
        return AutoMap{
            .map = std.AutoHashMap(u64, u64).init(alloc),
            .allocator = alloc,
        };
    }

    pub fn put(self: *AutoMap, key: u64, value: u64) !void {
        try self.map.put(key, value);
    }

    pub fn get(self: *AutoMap, key: u64) ?u64 {
        return self.map.get(key);
    }

    pub fn remove(self: *AutoMap, key: u64) !void {
        try self.map.remove(key);
    }

    pub fn deinit(self: *AutoMap) void {
        self.map.deinit();
    }
};

test "AutoMap basic operations" {
    var auto_map = try AutoMap.init(null);
    defer auto_map.deinit();

    try auto_map.put(1, 10);
    try auto_map.put(2, 20);

    try testing.expect(auto_map.get(1) == 10);
    try testing.expect(auto_map.get(2) == 20);
    try testing.expect(auto_map.get(3) == null);

    try auto_map.remove(1);
    try testing.expect(auto_map.get(1) == null);
}
