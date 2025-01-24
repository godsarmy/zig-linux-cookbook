## Overview
Examples of zig code to demonstrate how to use typical linux system lib in zig
namespace [std.os.linux](https://ziglang.org/documentation/master/std/#std.os.linux)

## Examples
| File                                       | Related Call |
| ------------------------------------------ | ------------ |
| [clock_gettime.zig](src/clock_gettime.zig) | [clock_gettime](https://ziglang.org/documentation/master/std/#std.os.linux.clock_gettime) |
| [dup2.zig](src/dup2.zig)                   | [dup2](https://ziglang.org/documentation/master/std/#std.os.linux.dup2) |
| [execve.zig](src/execve.zig)               | [execve](https://ziglang.org/documentation/master/std/#std.os.linux.execve) |
| [fork_waitpid.zig](src/fork_waitpid.zig)   | [fork](https://ziglang.org/documentation/master/std/#std.os.linux.fork) [waitpid](https://ziglang.org/documentation/master/std/#std.os.linux.waitpid) |
| [getcwd.zig](src/getcwd.zig)               | [getcwd](https://ziglang.org/documentation/master/std/#std.os.linux.getcwd) [chdir](https://ziglang.org/documentation/master/std/#std.os.linux.chdir) |
| [getgroups.zig](src/getgroups.zig)         | [getgroups](https://ziglang.org/documentation/master/std/#std.os.linux.getgroups) |
| [getrandom.zig](src/getrandom.zig)         | [getrandom](https://ziglang.org/documentation/master/std/#std.os.linux.getrandom) |
| [lstat.zig](src/lstat.zig)                 | [lstat](https://ziglang.org/documentation/master/std/#std.os.linux.lstat) |
| [kill.zig](src/kill.zig)                   | [kill](https://ziglang.org/documentation/master/std/#std.os.linux.kill) |
| [open_errno.zig](src/open_errno.zig)       | [open](https://ziglang.org/documentation/master/std/#std.os.linux.open) |
| [pipe.zig](src/pipe.zig)                   | [pipe](https://ziglang.org/documentation/master/std/#std.os.linux.pipe) [read](https://ziglang.org/documentation/master/std/#std.os.linux.read) [write](https://ziglang.org/documentation/master/std/#std.os.linux.write) |
| [symlink.zig](src/symlink.zig)             | [symlink](https://ziglang.org/documentation/master/std/#std.os.linux.symlink) [readlink](https://ziglang.org/documentation/master/std/#std.os.linux.readlink) |
| [ushare.zig](src/ushare.zig)               | [getuid](https://ziglang.org/documentation/master/std/#std.os.linux.getuid) [unshare](https://ziglang.org/documentation/master/std/#std.os.linux.unshare) |

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

## Other awesome zig learning materials
 * [zig-cookbook](https://github.com/zigcc/zig-cookbook)
 * [awesome-zig](https://github.com/zigcc/awesome-zig)
 * [zig-learning](https://github.com/zouyee/zig-learning)
