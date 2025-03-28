# Zig Linux System Programming Cookbook


## Overview
This repository is a collection of practical examples and recipes of
[std.os.linux](https://ziglang.org/documentation/master/std/#std.os.linux) for
developing applications and system tools using the [Zig](https://ziglang.org/)
programming language on Linux.

It's designed to be a helpful resource for Zig developers of all levels who
want to learn by example and quickly find solutions to port code of C system
calls into [Zig](https://ziglang.org/).

## Examples
| File                                       | Related Call |
| ------------------------------------------ | ------------ |
| [capget.zig](src/capget.zig)               | [capget](https://ziglang.org/documentation/master/std/#std.os.linux.capget) |
| [clock_gettime.zig](src/clock_gettime.zig) | [clock_gettime](https://ziglang.org/documentation/master/std/#std.os.linux.clock_gettime) |
| [clone_thread.zig](src/clone_thread.zig)   | [clone](https://ziglang.org/documentation/master/std/#std.os.linux.clone) [gettid](https://ziglang.org/documentation/master/std/#std.os.linux.gettid) |
| [dup2.zig](src/dup2.zig)                   | [dup2](https://ziglang.org/documentation/master/std/#std.os.linux.dup2) |
| [execve.zig](src/execve.zig)               | [execve](https://ziglang.org/documentation/master/std/#std.os.linux.execve) |
| [fork_waitpid.zig](src/fork_waitpid.zig)   | [fork](https://ziglang.org/documentation/master/std/#std.os.linux.fork) [waitpid](https://ziglang.org/documentation/master/std/#std.os.linux.waitpid) |
| [getcwd.zig](src/getcwd.zig)               | [getcwd](https://ziglang.org/documentation/master/std/#std.os.linux.getcwd) [chdir](https://ziglang.org/documentation/master/std/#std.os.linux.chdir) |
| [getdents64](src/getdents64.zig)           | [getdents64](https://ziglang.org/documentation/master/std/#std.os.linux.getdents64) |
| [getgroups.zig](src/getgroups.zig)         | [getgroups](https://ziglang.org/documentation/master/std/#std.os.linux.getgroups) |
| [getrandom.zig](src/getrandom.zig)         | [getrandom](https://ziglang.org/documentation/master/std/#std.os.linux.getrandom) |
| [ioctl.zig](src/ioctl.zig)                 | [ioctl](https://ziglang.org/documentation/master/std/#std.os.linux.ioctl) |
| [kill.zig](src/kill.zig)                   | [kill](https://ziglang.org/documentation/master/std/#std.os.linux.kill) |
| [lstat.zig](src/lstat.zig)                 | [lstat](https://ziglang.org/documentation/master/std/#std.os.linux.lstat) |
| [mmap.zig](src/mmap.zig)                   | [mmap](https://ziglang.org/documentation/master/std/#std.os.linux.mmap) [munmap](https://ziglang.org/documentation/master/std/#std.os.linux.munmap) |
| [open_errno.zig](src/open_errno.zig)       | [open](https://ziglang.org/documentation/master/std/#std.os.linux.open) |
| [pipe.zig](src/pipe.zig)                   | [pipe](https://ziglang.org/documentation/master/std/#std.os.linux.pipe) [read](https://ziglang.org/documentation/master/std/#std.os.linux.read) [write](https://ziglang.org/documentation/master/std/#std.os.linux.write) |
| [ptrace.zig](src/ptrace.zig)               | [ptrace](https://ziglang.org/documentation/master/std/#std.os.linux.ptrace) |
| [symlink.zig](src/symlink.zig)             | [symlink](https://ziglang.org/documentation/master/std/#std.os.linux.symlink) [readlink](https://ziglang.org/documentation/master/std/#std.os.linux.readlink) |
| [unshare.zig](src/unshare.zig)             | [getuid](https://ziglang.org/documentation/master/std/#std.os.linux.getuid) [unshare](https://ziglang.org/documentation/master/std/#std.os.linux.unshare) |
| [uname.zig](src/uname.zig)                 | [uname](https://ziglang.org/documentation/master/std/#std.os.linux.uname) |

## Usage
 * Install [zig >= 0.14](https://ziglang.org/download/)

 * Build Only.
```sh
zig build
```
You will have binaries in `zig-out/bin`.

 * Build & Run all
```sh
zig build run-all
```

## Other awesome zig learning materials
 * [zig-cookbook](https://github.com/zigcc/zig-cookbook)
 * [awesome-zig](https://github.com/zigcc/awesome-zig)
 * [zig-learning](https://github.com/zouyee/zig-learning)
 * [zig-book](https://github.com/pedropark99/zig-book)
 * [zig-guide](https://zig.guide/)
