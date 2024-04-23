const std = @import("std");
const debug = std.debug;

const http = @import("http.zig");

pub fn main() !void {
    var gpa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer gpa.deinit();
    const allocator = gpa.allocator();

    // const response = try http.get("http://httpbin.org/status/200");
    const client = http.Client.init(allocator);
    const response = try client.get("https://whatthecommit.com/");

    debug.print("Response({u}) {s}\n", .{ response.?.status, response.?.body });
}
