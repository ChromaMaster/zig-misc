const channel = @import("channel.zig");

const std = @import("std");
const testing = std.testing;
const threading = std.Thread;

test "communication works" {
    const producer = struct {
        fn run(chan: *channel.Channel([]const u8)) !void {
            try chan.write("Message!");
        }
    };

    const consumer = struct {
        fn run(chan: *channel.Channel([]const u8)) !void {
            _ = try chan.read();
        }
    };

    var chan = channel.Channel([]const u8).init();

    const producerT = try threading.spawn(.{}, producer.run, .{&chan});
    const consumerT = try threading.spawn(.{}, consumer.run, .{&chan});

    producerT.join();
    consumerT.join();
}
