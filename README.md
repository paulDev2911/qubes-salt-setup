# 🔒 Qubes OS Setup

[![Salt](https://img.shields.io/badge/Salt-State-blue.svg)](https://saltproject.io/)
[![Qubes](https://img.shields.io/badge/Qubes-R4.2-purple.svg)](https://www.qubes-os.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Signed](https://img.shields.io/badge/Commits-GPG%20Signed-brightgreen.svg)](SECURITY.md)

A highly secure, automated Qubes OS configuration using SaltStack. This setup implements defense-in-depth with compartmentalization for different security domains.

## 🎯 Features

- **Zero-Trust Architecture**: Complete isolation between security domains
- **Automated Deployment**: One-command setup via Salt
- **Split-GPG**: Hardware-backed key isolation
- **VPN Chaining**: Multi-hop VPN configuration
- **Minimal Attack Surface**: Debian-minimal based sys-qubes