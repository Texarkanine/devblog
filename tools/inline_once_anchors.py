"""Inline a reference link when its label is used once.

Footnotes ([^id]) are left alone. A label used twice or more keeps its
definition. Prints what it would change. Pass --write to change the file.

    python tools/inline_once_anchors.py post.md
    python tools/inline_once_anchors.py --write post.md

Link text may not contain a ']' or a newline. A destination with unbalanced
parentheses is wrapped in <>.
"""
import re
import sys

_FENCE = re.compile(r"(`{3,}|~{3,})(.*)")
_DEF = re.compile(r"^[ ]{0,3}\[([^\]\n]+)\]:[ \t]+(\S+)", re.M)
_USE = re.compile(r"(!?)\[([^\]\n]+)\]\[([^\]\n]*)\]")
_SHORT = re.compile(r"(?<!!)\[([^\]\n]+)\]")


def blank_code(text):
    """Return text with fenced blocks and inline code replaced by spaces.

    Newlines stay, and the result is the same length, so a match index in the
    blanked text is the same index in the original.
    """
    chars = list(text)
    pos = 0
    fence = None
    fence_at = 0
    for line in text.splitlines(keepends=True):
        marked = _FENCE.match(line.lstrip(" \t"))
        if marked:
            marker, rest = marked.group(1), marked.group(2).strip()
            opening = fence is None and "`" not in rest and "~" not in rest
            closing = (
                fence is not None
                and rest == ""
                and marker[0] == fence[0]
                and len(marker) >= len(fence)
            )
            if opening:
                fence, fence_at = marker, pos
            elif closing:
                _blank(chars, fence_at, pos + len(line))
                fence = None
        pos += len(line)

    i = 0
    while i < len(chars):
        if chars[i] != "`":
            i += 1
            continue
        n = 0
        while i + n < len(chars) and chars[i + n] == "`":
            n += 1
        end = _closer(chars, i + n, n)
        if end is None:
            i += n
            continue
        _blank(chars, i, end)
        i = end
    return "".join(chars)


def _blank(chars, start, end):
    for i in range(start, end):
        if chars[i] != "\n":
            chars[i] = " "


def _closer(chars, start, width):
    """Index just past a same-width backtick closer on this line, or None."""
    i = start
    while i < len(chars) and chars[i] != "\n":
        if chars[i] == "`":
            n = 0
            while i + n < len(chars) and chars[i + n] == "`":
                n += 1
            if n == width:
                return i + n
            i += n
        else:
            i += 1
    return None


def _line_span(text, index):
    start = text.rfind("\n", 0, index) + 1
    end = text.find("\n", index)
    return start, len(text) if end == -1 else end + 1


def _target(dest, rest):
    """The inside of (...): the url, plus a title when the definition has one."""
    if dest.startswith("<") and dest.endswith(">"):
        dest = dest[1:-1]
    depth = 0
    wrapped = False
    for char in dest:
        if char == "(":
            depth += 1
        elif char == ")":
            depth -= 1
            if depth < 0:
                wrapped = True
                break
    if depth != 0:
        wrapped = True
    if wrapped:
        dest = "<" + dest + ">"
    rest = rest.strip()
    if rest.startswith(('"', "'", "(")):
        end_char = ")" if rest[0] == "(" else rest[0]
        end = rest.find(end_char, 1)
        if end != -1:
            title = rest[1:end].replace("\\", "\\\\").replace('"', '\\"')
            dest += ' "' + title + '"'
    return dest


def inline_once(text):
    """Return (new text, report lines). text is unchanged when nothing qualifies."""
    masked = blank_code(text)
    definitions = {}
    duplicates = set()
    occupied = []
    for match in _DEF.finditer(masked):
        label = match.group(1)
        if label.startswith("^"):
            continue
        start, end = _line_span(text, match.start())
        occupied.append((start, end))
        key = label.strip().casefold()
        if key in definitions:
            duplicates.add(key)
        else:
            line_end = text.find("\n", match.end())
            rest = text[match.end() :] if line_end == -1 else text[match.end() : line_end]
            definitions[key] = (start, end, _target(match.group(2), rest), text.count("\n", 0, start) + 1)

    uses = {}

    def add(key, start, end, replacement, line):
        if key not in definitions:
            return
        uses.setdefault(key, []).append((start, end, replacement, line))
        occupied.append((start, end))

    for match in _USE.finditer(masked):
        label = match.group(3) or match.group(2)
        add(
            label.strip().casefold(),
            match.start(),
            match.end(),
            match.group(1) + "[" + match.group(2) + "]",
            text.count("\n", 0, match.start()) + 1,
        )
    for match in _SHORT.finditer(masked):
        if any(start <= match.start() and match.end() <= end for start, end in occupied):
            continue
        if match.end() < len(masked) and masked[match.end()] in "[(":
            continue
        add(
            match.group(1).strip().casefold(),
            match.start(),
            match.end(),
            "[" + match.group(1) + "]",
            text.count("\n", 0, match.start()) + 1,
        )

    report = []
    edits = []
    for key, (start, end, dest, def_line) in definitions.items():
        found = uses.get(key, [])
        if key in duplicates or len(found) != 1:
            continue
        use_start, use_end, prefix, use_line = found[0]
        report.append(f"line {use_line}: {prefix} -> {dest}; delete definition at line {def_line}")
        edits.append((use_start, use_end, prefix + "(" + dest + ")"))
        edits.append((start, end, ""))

    kept = sum(1 for key, found in uses.items() if len(found) > 1)
    unused = sum(1 for key in definitions if key not in uses)
    report.insert(0, f"{len(edits) // 2} single-use label(s); {kept} kept; {unused} unused, left in place")
    for key in sorted(duplicates):
        report.append(f"duplicate [{key}], left untouched")

    updated = text
    for start, end, replacement in sorted(edits, reverse=True):
        updated = updated[:start] + replacement + updated[end:]
    return updated, report


def main(argv):
    """Print the plan for each path. With --write, change the file too."""
    write = "--write" in argv
    paths = [arg for arg in argv if arg != "--write"]
    if not paths:
        print("usage: python tools/inline_once_anchors.py [--write] FILE ...", file=sys.stderr)
        return 1
    for path in paths:
        with open(path, encoding="utf-8") as handle:
            text = handle.read()
        updated, report = inline_once(text)
        print(path)
        print("\n".join(report))
        if write and updated != text:
            with open(path, "w", encoding="utf-8") as handle:
                handle.write(updated)
            print("wrote", path)
        elif not write:
            print("dry run. pass --write to change the file.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
