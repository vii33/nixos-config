#!/usr/bin/env python3
"""Exercise the Yazi/OC handoff without opening real agents or changing Herdr."""

import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


SCRIPTS = Path(__file__).resolve().parent
BASH = shutil.which("bash")


class OpenCodeOpenersTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="yazi-oc-test-")
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name).resolve()
        self.bin = self.root / "bin"
        self.bin.mkdir()
        self.log = self.root / "calls.jsonl"
        self.folder = self.root / "folder with 'quotes' and $dollars"
        self.folder.mkdir()
        self.file = self.folder / "file.txt"
        self.file.touch()
        self.env = os.environ | {
            "PATH": f"{self.bin}:{os.environ['PATH']}",
            "TEST_LOG": str(self.log),
            "TMPDIR": str(self.root),
            "HERDR_ENV": "1",
            "HERDR_PANE_ID": "caller:p1",
            "YAZI_OPENCODE_FILE": str(self.root / "handoff"),
        }
        for name in ("opencode", "ya", "herdr", "real-yazi"):
            self.mock(name)

    def mock(self, name):
        path = self.bin / name
        path.write_text(
            f"#!{shutil.which('python3')}\n"
            "import json, os, pathlib, subprocess, sys\n"
            "name = pathlib.Path(sys.argv[0]).name\n"
            "with open(os.environ['TEST_LOG'], 'a') as log:\n"
            "    log.write(json.dumps([name, sys.argv[1:], os.getcwd()]) + '\\n')\n"
            "if name == 'herdr' and sys.argv[1:3] == ['pane', 'split']:\n"
            "    if os.environ.get('SPLIT_FAIL'): sys.exit(1)\n"
            "    print(json.dumps({'result': {'pane': {'pane_id': 'new:p2'}}}))\n"
            "if name == 'real-yazi':\n"
            "    if os.environ.get('TEST_TARGET'):\n"
            f"        subprocess.run(['bash', {str(SCRIPTS / 'yazi-opencode.sh')!r},\n"
            "                        'quit', os.environ['TEST_TARGET']], check=True)\n"
            "    sys.exit(int(os.environ.get('YAZI_STATUS', '0')))\n"
        )
        path.chmod(0o755)

    def run_script(self, name, *args, **env):
        return subprocess.run(
            [BASH, str(SCRIPTS / name), *map(str, args)],
            env=self.env | env,
            capture_output=True,
            text=True,
            timeout=10,
        )

    def calls(self):
        return [json.loads(line) for line in self.log.read_text().splitlines()] \
            if self.log.exists() else []

    def test_quit_records_folder_and_emits_reserved_exit(self):
        result = self.run_script("yazi-opencode.sh", "quit", self.folder)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.root / "handoff").read_bytes(),
                         os.fsencode(self.folder) + b"\0")
        self.assertEqual(self.calls()[0][:2], ["ya", ["emit", "quit", "--code=90"]])

    def test_quit_uses_file_parent(self):
        result = self.run_script("yazi-opencode.sh", "quit", self.file)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.root / "handoff").read_bytes(),
                         os.fsencode(self.folder) + b"\0")

    def test_quit_requires_launcher(self):
        result = self.run_script("yazi-opencode.sh", "quit", self.folder,
                                 YAZI_OPENCODE_FILE="")
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(self.calls(), [])

    def test_missing_opencode_does_not_quit_or_split(self):
        (self.bin / "opencode").unlink()
        for mode in ("quit", "pane"):
            result = self.run_script("yazi-opencode.sh", mode, self.folder,
                                     PATH=str(self.bin))
            self.assertNotEqual(result.returncode, 0)
        self.assertEqual(self.calls(), [])

    def test_handoff_exits_yazi_before_opening_oc_and_preserves_arguments(self):
        result = self.run_script(
            "yazi-launcher.sh", self.folder, "--cwd-file=caller-file",
            YAZI_REAL_BIN=str(self.bin / "real-yazi"),
            TEST_TARGET=str(self.file), YAZI_STATUS="90",
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        calls = self.calls()
        self.assertEqual([call[0] for call in calls], ["real-yazi", "ya", "opencode"])
        self.assertEqual(calls[0][1], [str(self.folder), "--cwd-file=caller-file"])
        self.assertEqual(calls[-1][1:], [[str(self.folder)], str(self.folder)])
        self.assertEqual(list(self.root.glob("yazi-opencode.*")), [])

    def test_launcher_preserves_ordinary_exit_codes(self):
        for status in (0, 1, 90, 130):
            with self.subTest(status=status):
                result = self.run_script("yazi-launcher.sh",
                                         YAZI_REAL_BIN=str(self.bin / "real-yazi"),
                                         YAZI_STATUS=str(status))
                self.assertEqual(result.returncode, status, result.stderr)
        self.assertNotIn("opencode", [call[0] for call in self.calls()])

    def test_pane_splits_caller_down_and_runs_in_returned_pane(self):
        result = self.run_script("yazi-opencode.sh", "pane", self.folder)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual([call[:2] for call in self.calls()], [
            ["herdr", ["pane", "split", "--current", "--direction", "down",
                       "--cwd", str(self.folder), "--focus"]],
            ["herdr", ["pane", "run", "new:p2", "opencode"]],
        ])

    def test_pane_uses_file_parent(self):
        result = self.run_script("yazi-opencode.sh", "pane", self.file)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(str(self.folder), self.calls()[0][1])

    def test_pane_requires_herdr_and_caller_identity(self):
        for env in ({"HERDR_ENV": ""}, {"HERDR_PANE_ID": ""}):
            result = self.run_script("yazi-opencode.sh", "pane", self.folder, **env)
            self.assertNotEqual(result.returncode, 0)
        self.assertEqual(self.calls(), [])

    def test_failed_split_does_not_run_command(self):
        result = self.run_script("yazi-opencode.sh", "pane", self.folder, SPLIT_FAIL="1")
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(len(self.calls()), 1)

    def test_invalid_target_and_mode_do_not_mutate_anything(self):
        for mode, target in (("quit", self.root / "missing"), ("bad", self.folder)):
            result = self.run_script("yazi-opencode.sh", mode, target)
            self.assertNotEqual(result.returncode, 0)
        self.assertEqual(self.calls(), [])

    def test_handoff_preserves_newlines_in_directory_name(self):
        folder = self.root / "folder\nwith newline"
        folder.mkdir()
        result = self.run_script("yazi-launcher.sh",
                                 YAZI_REAL_BIN=str(self.bin / "real-yazi"),
                                 TEST_TARGET=str(folder), YAZI_STATUS="90")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.calls()[-1][1], [str(folder)])


if __name__ == "__main__":
    unittest.main()
