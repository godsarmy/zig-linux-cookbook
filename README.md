## Overview
Show usage linux system call in zig namespace
[std.os.linux](https://ziglang.org/documentation/master/std/#std.os.linux)

## Examples
| File                                       | Related Call |
| ------------------------------------------ | ------------ |
| [clock_gettime.zig](src/clock_gettime.zig) | [clock_gettime](https://ziglang.org/documentation/master/std/#std.os.linux.clock_gettime) |
| [dup2.zig](src/dup2.zig)                   | [dup2](https://ziglang.org/documentation/master/std/#std.os.linux.dup2) |
| [execve.zig](src/execve.zig)               | [execve](https://ziglang.org/documentation/master/std/#std.os.linux.execve) |
| [fork_waitpid.zig](src/fork_waitpid.zig)   | [fork](https://ziglang.org/documentation/master/std/#std.os.linux.fork) [waitpid](https://ziglang.org/documentation/master/std/#std.os.linux.waitpid) |
| [getcwd.zig](src/getcwd.zig)               | [getcwd](https://ziglang.org/documentation/master/std/#std.os.linux.getcwd) |
| [getgroups.zig](src/getgroups.zig)         | [getgroups](https://ziglang.org/documentation/master/std/#std.os.linux.getgroups) |
| [lstat.zig](src/lstat.zig)                 | [lstat](https://ziglang.org/documentation/master/std/#std.os.linux.lstat) |
| [open_errno.zig](src/open_errno.zig)       | [open](https://ziglang.org/documentation/master/std/#std.os.linux.open) |
| [symlink.zig](src/symlink.zig)             | [symlink](https://ziglang.org/documentation/master/std/#std.os.linux.symlink) [readlink](https://ziglang.org/documentation/master/std/#std.os.linux.readlink) |

## Usage
 * Install [zig >= 0.13](https://ziglang.org/download/)
 * Build Only
```sh
zig build
```
 * Build & Run all
```sh
zig build run-all
```
