//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const testing = std.testing;

pub fn AutoMap(comptime K: type, comptime V: type) type {
    return struct {
        map: std.AutoHashMap(K, V),
        allocator: std.mem.Allocator,

        pub fn init(allocator: ?std.mem.Allocator) !@This() {
            const alloc = allocator orelse std.heap.page_allocator;
            return .{
                .map = std.AutoHashMap(K, V).init(alloc),
                .allocator = alloc,
            };
        }

        pub fn put(self: *@This(), key: K, value: V) !void {
            try self.map.put(key, value);
        }

        pub fn get(self: *@This(), key: K) ?V {
            return self.map.get(key);
        }

        pub fn remove(self: *@This(), key: K) bool {
            return self.map.remove(key);
        }

        pub fn deinit(self: *@This()) void {
            self.map.deinit();
        }
    };
}

pub fn AutoSet(comptime K: type) type {
    return struct {
        set: std.AutoHashMap(K, u64),
        allocator: std.mem.Allocator,

        pub fn init(allocator: ?std.mem.Allocator) !@This() {
            const alloc = allocator orelse std.heap.page_allocator;
            return .{
                .set = std.AutoHashMap(K, u64).init(alloc),
                .allocator = alloc,
            };
        }

        pub fn put(self: *@This(), value: K) !void {
            try self.set.put(value, 0);
        }

        pub fn contains(self: *@This(), value: K) bool {
            return self.set.contains(value);
        }

        pub fn remove(self: *@This(), value: K) bool {
            return self.set.remove(value);
        }

        pub fn deinit(self: *@This()) void {
            self.set.deinit();
        }
    };
}

pub fn AutoArrayList(comptime V: type) type {
    return struct {
        list: std.ArrayList(V),
        allocator: std.mem.Allocator,

        pub fn init(allocator: ?std.mem.Allocator) !@This() {
            const alloc = allocator orelse std.heap.page_allocator;
            return .{
                .list = std.ArrayList(V).init(alloc),
                .allocator = alloc,
            };
        }

        pub fn append(self: *@This(), value: V) !void {
            try self.list.append(value);
        }

        pub fn get(self: *@This(), index: usize) ?V {
            if (index >= self.list.items.len) {
                return null;
            }
            return self.list.items[index];
        }

        pub fn remove(self: *@This(), index: usize) !V {
            if (index >= self.list.items.len) {
                return error.IndexOutOfBounds;
            }
            return self.list.orderedRemove(index);
        }

        pub fn deinit(self: *@This()) void {
            self.list.deinit();
        }
    };
}

test "AutoMap basic operations" {
    const MyMap = AutoMap(u64, u64);
    var auto_map = try MyMap.init(null);
    defer auto_map.deinit();

    try auto_map.put(1, 10);
    try auto_map.put(2, 20);

    try testing.expect(auto_map.get(1) == 10);
    try testing.expect(auto_map.get(2) == 20);
    try testing.expect(auto_map.get(3) == null);

    _ = auto_map.remove(1);
    try testing.expect(auto_map.get(1) == null);
}

test "AutoSet basic operations" {
    const MySet = AutoSet(u64);
    var auto_set = try MySet.init(null);
    defer auto_set.deinit();

    try auto_set.put(1);
    try auto_set.put(2);

    try testing.expect(auto_set.contains(1));
    try testing.expect(auto_set.contains(2));
    try testing.expect(!auto_set.contains(3));

    _ = auto_set.remove(1);
    try testing.expect(!auto_set.contains(1));
}

test "AutoArrayList basic operations" {
    const MyList = AutoArrayList(u64);
    var auto_array_list = try MyList.init(null);
    defer auto_array_list.deinit();

    try auto_array_list.append(10);
    try auto_array_list.append(20);

    try testing.expect(auto_array_list.get(0) == 10);
    try testing.expect(auto_array_list.get(1) == 20);
    try testing.expect(auto_array_list.get(2) == null);

    _ = try auto_array_list.remove(0);
    try testing.expect(auto_array_list.get(0) == 20);
    try testing.expect(auto_array_list.get(1) == null);
}
