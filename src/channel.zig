const std = @import("std");
const Allocator = std.mem.Allocator;

const Mutex = std.Thread.Mutex;
const Condition = std.Thread.Condition;

pub fn Channel(comptime T: type) type {
    return struct {
        const Self = @This();

        m: Mutex = .{},
        cond: Condition = .{},

        val: T,
        valid: bool,

        pub fn init() Self {
            return Self{
                .val = undefined,
                .valid = false,
            };
        }

        pub fn write(self: *Self, item: T) !void {
            self.m.lock();
            defer self.m.unlock();

            self.val = item;
            self.valid = true;

            self.cond.signal();
        }

        pub fn read(self: *Self) !T {
            self.m.lock();
            defer self.m.unlock();

            if (!self.valid) {
                self.cond.wait(&self.m);
            }

            self.valid = false;
            return self.val;
        }
    };
}
