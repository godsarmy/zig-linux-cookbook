## Overview
Show usage linux system call in zig namespace
[std.os.linux](https://ziglang.org/documentation/master/std/#std.os.linux)

## Examples
| File                                     | Related Call |
| ---------------------------------------- | ------------ |
| [dup2.zig](src/dup2.zig)                 | [dup2](https://ziglang.org/documentation/master/std/#std.os.linux.dup2) |
| [fork_waitpid.zig](src/fork_waitpid.zig) | [fork](https://ziglang.org/documentation/master/std/#std.os.linux.fork) [waitpid](https://ziglang.org/documentation/master/std/#std.os.linux.waitpid) |
| [getcwd.zig]（src/getcwd.zig)            | [getcwd](https://ziglang.org/documentation/master/std/#std.os.linux.getcwd) |
| [lstat.zig](src/lstat.zig)               | [lstat](https://ziglang.org/documentation/master/std/#std.os.linux.lstat) |
| [open_errno.zig](src/open_errno.zig)     | [open](https://ziglang.org/documentation/master/std/#std.os.linux.open) |

## Usage
 * Build Only
```sh
zig build
```
 * Build & Run all
```sh
zig build run-all
```
