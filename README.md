# Shocked 30 — Console 3

**Current package:** `30.0.0-8+console3`  
**Architecture:** `amd64`  
**OS:** Kubuntu 26.04 LTS ---ONLY---

**License:** Proprietary

Shocked is an adaptive Linux power-management daemon with a native system
console, tray integration, verified hardware-control readback, transactional
rollback, safety limits, and local diagnostics.

## Download

Canonical release asset:

[`shocked-console3_30.0.0-8+console3_amd64.deb`](https://github.com/chasemiracleborn/Shocked/releases/download/v30.0.0/shocked-console3_30.0.0-8+console3_amd64.deb)

SHA-256:

```text
503b656e2454a1d30b4921089abd96f4ed72937255c035f238ebfcb64841c7f0
```

## Install

```bash
sudo apt install ./shocked-console3_30.0.0-8+console3_amd64.deb
```

Or:

```bash
bash ./install-shocked-30.0.0.sh
```

<img width="2560" height="1393" alt="image" src="https://github.com/user-attachments/assets/1188aad3-965a-457a-b9c4-cd4775673ab3" />

<img width="2560" height="1393" alt="image" src="https://github.com/user-attachments/assets/7170cd37-a882-4ca8-893a-5c7c8d360ff5" />

<img width="2560" height="1393" alt="image" src="https://github.com/user-attachments/assets/8edbbf3b-f4b6-4ced-bff6-224e7a503bdc" />

<img width="2560" height="1393" alt="image" src="https://github.com/user-attachments/assets/88d8ba4d-c968-4605-a675-9da947912933" />

<img width="2560" height="1393" alt="image" src="https://github.com/user-attachments/assets/92163447-ff04-479b-98cc-cff53ac4ea67" />

## Capabilities

- Drift, Power-Saver, Balanced, Glide, Performance, and Surge profiles.
- Manual Super mode, automatic Impulse behavior, and bounded Limit Break bursts.
- Limit Break charges from qualifying load over a rolling window; qualifying time does not need to be consecutive.
- Driver-aware CPU policy control with apply/readback verification.
- Thermal, battery, GPU, transaction rollback, and incident safeguards.
- Native tray and Console 3 telemetry/control interface.
- Optional forced AC brightness authority from Console Settings.
- Explicit, privacy-minimized bug reporting.
- No background telemetry or automatic bug-report submission.

## Package behavior

Package transactions are deliberately non-interactive:

- no KDialog or Zenity
- no automatic Snapper/Timeshift execution
- no package-time writes into user home directories
- payload replacement stays under dpkg ownership

Optional pre-install snapshots remain available through the standalone
installer wrapper.

## Privacy

See [PRIVACY.md](PRIVACY.md).

## Verify

```bash
sha256sum shocked-console3_30.0.0-8+console3_amd64.deb
```

Expected:

```text
503b656e2454a1d30b4921089abd96f4ed72937255c035f238ebfcb64841c7f0  shocked-console3_30.0.0-8+console3_amd64.deb
```

## Documentation

- [Installation](INSTALL.md)
- [Support](SUPPORT.md)
- [Privacy](PRIVACY.md)
- [Security](SECURITY.md)
- [Contributing](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)
- [Release notes](RELEASE-NOTES-30.0.0.md)
- [License](LICENSE)

## Remove

```bash
sudo apt remove shocked
```
