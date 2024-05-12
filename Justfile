default: run

run: 
	zig build run

test-setup:
	podman run -d --name zig-test-setup -p 35565:80 docker.io/kennethreitz/httpbin

test: test-setup && test-teardown
	-find ./src -type f -iname "*.zig" | xargs -i zig test {}

test-teardown:
	podman stop zig-test-setup && podman rm zig-test-setup

clean:
	rm -rf zig-out zig-cache
