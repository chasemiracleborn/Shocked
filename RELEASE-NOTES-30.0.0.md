# Shocked 30.0.0 — Console 3

**Debian revision:** `30.0.0-8+console3`  
**Architecture:** `amd64`

## What changed

- Limit Break now accumulates qualifying workload time over a rolling window instead of requiring one uninterrupted charge period.
- Short non-qualifying gaps no longer immediately drain Limit Break charge; old qualifying time expires naturally as it leaves the window.
- Limit Break workload detection is less restrictive on high-core-count systems and no longer requires the CPU to already be near maximum frequency before charging.
- The forced AC brightness behavior can be enabled or disabled from Console Settings.
- The global systemd user-session tray autostart link is restored in the Debian package.
- Unrelated Shocked runtime functionality was preserved while these changes were made.

## Verification

The 30.0.0-8 source passed format, check, test, Clippy, documentation, release-build, source/package parity, privacy, and feature-retention gates. The Rust suite completed with 95 tests passing and no failures.

The public package was additionally scrubbed to remove local build-home paths and placeholder maintainer contact data before release.

## Install

```bash
sudo apt install ./shocked-console3_30.0.0-8+console3_amd64.deb
```

SHA-256:

```text
503b656e2454a1d30b4921089abd96f4ed72937255c035f238ebfcb64841c7f0  shocked-console3_30.0.0-8+console3_amd64.deb
```
