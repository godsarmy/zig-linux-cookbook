# Zig Linux System Programming Cookbook


## Overview
This repository is a collection of practical examples and recipes of
[std.os.linux](https://ziglang.org/documentation/0.17.0/std/#std.os.linux) for
developing applications and system tools using the [Zig](https://ziglang.org/)
programming language on Linux.

It's designed to be a helpful resource for Zig developers of all levels who
want to learn by example and quickly find solutions to port code of C system
calls into [Zig](https://ziglang.org/).

## Examples
| File                                       | Related Call |
| ------------------------------------------ | ------------ |
| [capget.zig](src/capget.zig)               | [capget](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.capget) |
| [clock_gettime.zig](src/clock_gettime.zig) | [clock_gettime](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.clock_gettime) |
| [clone_thread.zig](src/clone_thread.zig)   | [clone](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.clone) [gettid](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.gettid) |
| [dup2.zig](src/dup2.zig)                   | [dup2](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.dup2) |
| [execve.zig](src/execve.zig)               | [execve](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.execve) |
| [fork_waitpid.zig](src/fork_waitpid.zig)   | [fork](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.fork) [waitpid](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.waitpid) |
| [getcwd.zig](src/getcwd.zig)               | [getcwd](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.getcwd) [chdir](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.chdir) |
| [getdents64](src/getdents64.zig)           | [getdents64](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.getdents64) |
| [getgroups.zig](src/getgroups.zig)         | [getgroups](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.getgroups) |
| [getrandom.zig](src/getrandom.zig)         | [getrandom](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.getrandom) |
| [ioctl.zig](src/ioctl.zig)                 | [ioctl](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.ioctl) |
| [kill.zig](src/kill.zig)                   | [kill](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.kill) |
| [statx.zig](src/statx.zig)                 | [statx](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.statx) |
| [mmap.zig](src/mmap.zig)                   | [mmap](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.mmap) [munmap](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.munmap) |
| [open_errno.zig](src/open_errno.zig)       | [open](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.open) |
| [pipe.zig](src/pipe.zig)                   | [pipe](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.pipe) [read](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.read) [write](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.write) |
| [ptrace.zig](src/ptrace.zig)               | [ptrace](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.ptrace) |
| [symlink.zig](src/symlink.zig)             | [symlink](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.symlink) [readlink](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.readlink) |
| [unshare.zig](src/unshare.zig)             | [getuid](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.getuid) [unshare](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.unshare) |
| [uname.zig](src/uname.zig)                 | [uname](https://ziglang.org/documentation/0.17.0/std/#std.os.linux.uname) |
| [file_copy.zig](src/file_copy.zig) | openat, read, write, lseek, close |
| [tcp_echo.zig](src/tcp_echo.zig) | socket, bind, listen, getsockname, connect, accept4, read, write |
| [poll.zig](src/poll.zig) | pipe2, poll, read, write, close |
| [epoll.zig](src/epoll.zig) | epoll_create1, epoll_ctl, epoll_wait, pipe2 |
| [inotify.zig](src/inotify.zig) | inotify_init1, inotify_add_watch, read |
| [redirect_exec.zig](src/redirect_exec.zig) | pipe2, fork, dup2, execve, read, waitpid |

## Usage
 * Install [zig >= 0.17.0](https://ziglang.org/download/)

 * Build Only.
```sh
zig build
```
You will have binaries in `zig-out/bin`.

 * Build & Run all
```sh
zig build run-all
```

## Running individual examples

Run a single recipe with `zig build run-<name>`, for example:

```sh
zig build run-file_copy
```

The practical recipes print their results and exit automatically. They use
private temporary files or local sockets and require no root privileges.
`zig build check` compiles all recipes without running them.

Run the practical recipes with external timeouts and output checks:

```sh
python3 tests/smoke.py
```

## Practical recipes

* `file_copy`: Copy a file in chunks, handling EOF and short writes.

* `tcp_echo`: Exchange a message between a blocking loopback TCP client and server on an ephemeral port.

* `poll`: Wait for a pipe to become readable, then read its data.

* `epoll`: Register one pipe with epoll and read it when an event arrives.

* `inotify`: Watch a private temporary directory and print a file-creation event.

* `redirect_exec`: Redirect a child command’s stdout into a pipe, print it, and wait for the child.



## Other awesome zig learning materials
 * [zig-cookbook](https://github.com/zigcc/zig-cookbook)
 * [awesome-zig](https://github.com/zigcc/awesome-zig)
 * [zig-learning](https://github.com/zouyee/zig-learning)
 * [zig-book](https://github.com/pedropark99/zig-book)
 * [zig-guide](https://zig.guide/)
