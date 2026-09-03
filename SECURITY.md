# Security Policy

## Supported release

The supported release is Shocked `30.0.0-8+console3`.

## Reporting a vulnerability

Do not post credentials, private system information, exploit details, or a
working proof-of-concept in a public issue.

For an installed copy of Shocked, use **Report Bug** and prefix the title with:

```text
SECURITY:
```

Submission occurs only after **SEND REPORT** is pressed.

If GitHub Private Vulnerability Reporting is enabled for this repository, that
is also an appropriate channel.

## Bug-report privacy

The report client is designed to send the user-entered title/details plus
Shocked version, OS, kernel, architecture, and active profile. It does not
deliberately add the local username, hostname, home path, private destination
mailbox, or mail-service credentials.

## Local security model

The privileged daemon owns hardware policy. Console 3 communicates through a
per-launch authenticated loopback bridge. Browser-origin requests are rejected.
System services use sandboxing and high-risk control paths use validation,
readback, and rollback mechanisms.
