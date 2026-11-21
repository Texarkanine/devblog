"""nginx-proxy must run a build that includes the 18 Nov 2026 nginx fixes.

CVE-2026-123007 and CVE-2026-123633 are fixed in nginx 1.30.7 (stable)
and 1.31.9 (mainline). nginx.org lists every older release through 1.31.8
as vulnerable. The image is also digest-pinned, and it has to stay Alpine
because the Dockerfile installs packages with apk.
"""
import re
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
DOCKERFILE = REPO_ROOT / "nginx-proxy" / "Dockerfile"
FROM_LINE = re.compile(
    r"^FROM nginx:(?P<major>\d+)\.(?P<minor>\d+)\.(?P<patch>\d+)"
    r"(?P<variant>[^\s@]*)@sha256:(?P<digest>[0-9a-f]{64})\s*$"
)
# Stable (even minor) fixes landed in 1.30.7. Mainline (odd minor) fixes
# landed in 1.31.9. A later stable such as 1.32 is above 1.30.7.
STABLE_FLOOR = (1, 30, 7)
MAINLINE_FLOOR = (1, 31, 9)


def patched(version):
    """Return whether this nginx release is at or above the 18 Nov 2026 fixes."""
    major, minor, patch = version
    if major > 1:
        return True
    if major < 1:
        return False
    if minor % 2 == 0:
        return (major, minor, patch) >= STABLE_FLOOR
    return (major, minor, patch) >= MAINLINE_FLOOR


class NginxProxyBaseImageTests(unittest.TestCase):
    def test_base_image_is_a_patched_alpine_nginx_pinned_by_digest(self):
        """The FROM line names a patched Alpine nginx and pins its digest."""
        text = DOCKERFILE.read_text()
        from_lines = [line for line in text.splitlines() if line.startswith("FROM ")]
        self.assertEqual(len(from_lines), 1, from_lines)
        match = FROM_LINE.match(from_lines[0])
        self.assertIsNotNone(match, from_lines[0])
        version = tuple(int(match.group(name)) for name in ("major", "minor", "patch"))
        self.assertTrue(patched(version), version)
        self.assertTrue(match.group("variant").startswith("-alpine"), match.group("variant"))


if __name__ == "__main__":
    unittest.main()
