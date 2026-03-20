# pt - Pytest Output Compressor

> **Prerequisite:** `pt` requires [pytest](https://docs.pytest.org/) to be installed in your environment. That's it. `pt` does not replace pytest, extend pytest, or do anything magical — it simply **calls pytest, captures the output, and reformats it**. Same tests, same results, just compressed. If `pytest` works in your project, `pt` will work too.

## The problem

You run `pytest`. 200 tests execute. 3 fail. Your terminal explodes with 2000 lines of green noise, stack traces buried in walls of output, and a scrollback buffer you'll never recover from.

Now imagine you're feeding that output to an LLM.

Those 2000 lines of pytest output? That's **~6000 tokens** of pure waste. Your LLM is burning credits parsing passing tests, ANSI color codes, and duplicated tracebacks it doesn't care about. And when it finally finds the actual errors, it's already drowning in context — three unrelated failures competing for attention in a single prompt.

**You're paying your LLM to read your passing tests.**

## The idea

What if pytest output was... just the errors?

What if each failure lived in its own file — isolated, focused, ready to be fed to an LLM one at a time?

That's `pt`.

## How it works

`pt` wraps pytest and gives you two things:

1. **A one-line summary** of your test run — how many passed, failed, skipped. Nothing else.

2. **One file per failure** in `.pytest_errors/`. Each file contains only the traceback for that specific test. No noise. No context pollution.

```
📊 Test Summary: 2 failed, 18 passed
----------------------------------------
Here are all failed tests:
- tests/test_api.py:42: AssertionError 📂 [Trace: .pytest_errors/test_get_user.log]
- tests/test_models.py:15: KeyError: 'name' 📂 [Trace: .pytest_errors/test_create.log]
```

Each LLM call sees **one problem**. No distractions. No wasted tokens. No confused model trying to fix three unrelated things at once.

## The math

| Scenario | Tokens (approx) |
|----------|-----------------|
| Raw `pytest` output (200 tests, 3 failures) | ~6,000 |
| `pt` summary line | ~30 |
| Single failure trace file | ~150 |

That's a **40x reduction** in tokens per prompt. On a real project with verbose test suites, it's even more dramatic.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/Virgin75/pt/main/install.sh | bash
```

Or clone and run locally:

```bash
git clone https://github.com/virgin/pt.git
cd pt
chmod +x install.sh
./install.sh
```

The installer detects your shell (zsh/bash) and appends the `pt` function to `~/.zshrc` and/or `~/.bashrc`.

Restart your shell or run `source ~/.zshrc` (or `~/.bashrc`).

## Usage

```bash
# Run all tests
pt

# Pass any pytest arguments — pt is a drop-in replacement
pt tests/ -k test_login -v

# Run a specific file
pt tests/test_models.py
```

`pt` accepts every argument `pytest` does. It just gives you less noise.

## OpenCode plugin

There's an [OpenCode](https://opencode.ai) plugin that **automatically replaces every `pytest` command with `pt`**. When the AI agent runs your tests, it gets the compressed output instead of the full wall of text — no manual intervention needed.

### Install

```bash
curl -fsSL https://raw.githubusercontent.com/Virgin75/pt/main/install-opencode-plugin.sh | bash
```

That's it. Next time OpenCode runs a bash command containing `pytest`, the plugin intercepts it and swaps it for `pt`. The AI sees only the compressed summary and trace file paths — fewer tokens, faster fixes.

## Output files

All artifacts land in `.pytest_errors/` in your working directory:

| File | Content |
|------|---------|
| `report.xml` | Full JUnit XML report |
| `console.log` | Raw pytest stdout/stderr (if you ever need it) |
| `<test_name>.log` | One traceback per failure — your LLM's new best friend |

The directory is cleaned on every run. No stale errors. No confusion.
