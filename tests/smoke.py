"""Build and run the practical recipes with external output checks and timeouts."""
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
EXAMPLES = {
    'redirect_exec': 'captured child output\n',
    'inotify': 'inotify: created watched.txt',
    'epoll': 'epoll: pipe is readable: x',
    'poll': 'poll: pipe is readable: x',
    'tcp_echo': ': hello over TCP',
    'file_copy': 'Copied 36 bytes',
}

subprocess.run(["zig", "build"], cwd=ROOT, check=True)
for name, expected in EXAMPLES.items():
    result = subprocess.run(
        [str(ROOT / "zig-out" / "bin" / name)],
        cwd=ROOT, capture_output=True, text=True, timeout=5, check=True,
    )
    output = result.stdout + result.stderr
    if expected not in output:
        raise AssertionError(f"{name}: expected {expected!r}, got {output!r}")
    print(f"{name}: passed")
