const http = @import("http.zig");

const std = @import("std");
const testing = std.testing;
const allocator = testing.allocator;

const host = "http://localhost:35565";

test "HTTP GET returns correct status code 200" {
    const client = http.Client.init(allocator);

    const response = try client.get(host ++ "/get");
    defer response.?.deinit();

    try testing.expect(response.?.status == 200);

    try testing.expect(1 == 1);
}

test "HTTP GET returns correct status code 404" {
    const client = http.Client.init(allocator);

    const response = try client.get(host ++ "/not-found");
    defer response.?.deinit();

    try testing.expect(response.?.status == 404);

    try testing.expect(1 == 1);
}
