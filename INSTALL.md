# Installing Shocked 30

Supported package:

`shocked-console3_30.0.0-8+console3_amd64.deb`

SHA-256:

```text
503b656e2454a1d30b4921089abd96f4ed72937255c035f238ebfcb64841c7f0
```

Install directly:

```bash
sudo apt install ./shocked-console3_30.0.0-8+console3_amd64.deb
```

Or use the optional wrapper:

```bash
bash ./install-shocked-30.0.0.sh
```

The wrapper verifies the exact release SHA-256 and can optionally create a
Snapper and/or Timeshift snapshot before invoking APT. The Debian package
itself does not launch snapshot tools or desktop dialogs.

After installation:

```bash
systemctl status shocked.service --no-pager
shocked-ctl doctor
shocked-console
```

Remove:

```bash
sudo apt remove shocked
```
