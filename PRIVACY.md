# Privacy

Shocked is designed to operate locally. It does not perform background telemetry collection and does not automatically submit bug reports.

## Bug reports

The in-app **Report Bug** action submits only after the user explicitly presses **SEND REPORT**.

The report payload is designed to contain:

- the title and details entered by the user
- Shocked version
- operating-system information
- kernel version
- CPU architecture
- active Shocked profile

Shocked does not deliberately add the local username, hostname, home-directory path, private destination mailbox, or mail-service credentials.

Reports are sent over HTTPS through the project's public Formspree endpoint. The private destination mailbox and Formspree account credentials are not embedded in the distributed package.

**COPY REPORT** is available when the user prefers to keep the report local or submit it another way.

## Donations

The **Donate** action opens the official Shocked Project PayPal-hosted checkout in the user's browser. Shocked does not process card details, PayPal credentials, or banking information.

## Local data

Shocked stores its own system data under these locations:

- configuration: `/etc/shocked/`
- state: `/var/lib/shocked/`
- logs: `/var/log/shocked/`
- runtime state/socket: `/run/shocked/`

## Public GitHub issues

GitHub issues are public when this repository is public. Do not post credentials, private logs, home-directory paths, account identifiers, or unrelated personal information in an issue.
