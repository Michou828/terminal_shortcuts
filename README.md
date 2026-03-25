# Terminal Shortcuts for Embedded Development

A centralized repository for custom terminal shortcuts, aliases, and functions. This setup is designed to streamline embedded development workflows (particularly for ESP32 and SAMD21 projects) and make PlatformIO (`pio`) commands faster to type.

## Quick Install

You can install and apply these shortcuts on any new macOS or Linux machine with a single, clean command. Open your terminal and paste:

```zsh
curl -fsSL https://michou828.github.io/terminal_shortcuts/install.sh | zsh
```

Then reload your shell:

```zsh
source ~/.zshrc
```

---

## Available Shortcuts

Run `ls_edsc` at any time to print a help menu directly in your terminal.

---

### `ed_u` — Upload Firmware (PlatformIO)

Runs `pio run` to build and upload firmware to a device.

```zsh
ed_u [-e env] [-p port] [-t target]
```

| Flag | Required | Description |
|------|----------|-------------|
| `-e <env>` | No | PlatformIO environment name (from `platformio.ini`, e.g. `esp32`). If omitted and environments are defined in `platformio.ini`, you will be warned and prompted to confirm. |
| `-p <port>` | No | Port identifier. Use `m<num>` for usbmodem (e.g. `m101`) or `s<num>` for usbserial (e.g. `s101`). If omitted, PlatformIO auto-detects. |
| `-t <target>` | No | PlatformIO target. Defaults to `upload`. Use `uploadfs` to upload the filesystem image. |

Flags can be passed in any order.

**Examples:**
```zsh
ed_u                          # simple project, no env defined — auto-detects port
ed_u -e esp32                 # specify env, auto-detect port
ed_u -e esp32 -p m101         # env + modem port
ed_u -p s101 -t uploadfs      # serial port + filesystem upload, no env
ed_u -e esp32 -p m101 -t uploadfs  # full control
```

**Backward-compatible positional style still works:**
```zsh
ed_u esp32 101 upload
```

---

### `ed_m` — Open Serial Monitor (PlatformIO)

Opens a serial monitor using `pio device monitor`.

```zsh
ed_m -p <port> [-b baud]
```

| Flag | Required | Description |
|------|----------|-------------|
| `-p <port>` | Yes | Port identifier. Use `m<num>` for usbmodem or `s<num>` for usbserial. Uses `/dev/cu.*` path. |
| `-b <baud>` | No | Baud rate. Defaults to `115200`. |

**Examples:**
```zsh
ed_m -p m101              # monitor /dev/cu.usbmodem101 at 115200 baud
ed_m -p s101 -b 9600      # monitor /dev/cu.usbserial101 at 9600 baud
```

**Backward-compatible positional style still works:**
```zsh
ed_m 101
ed_m 101 9600
```

---

### `ed_s` — Open Serial Monitor (screen)

Opens a serial connection to a device using `screen`.

```zsh
ed_s -p <port> [-b baud]
```

| Flag | Required | Description |
|------|----------|-------------|
| `-p <port>` | Yes | Port identifier. Use `m<num>` for usbmodem or `s<num>` for usbserial. Uses `/dev/tty.*` path. |
| `-b <baud>` | No | Baud rate. Defaults to `115200`. |

**Examples:**
```zsh
ed_s -p m101              # connects to /dev/tty.usbmodem101 at 115200 baud
ed_s -p s101 -b 9600      # connects to /dev/tty.usbserial101 at 9600 baud
```

**Backward-compatible positional style still works:**
```zsh
ed_s 101
ed_s 101 9600
```

---

### `ed_ls` — List Serial Devices

Lists all available serial devices under `/dev/`.

```zsh
ed_ls
```

No parameters. Shows both `/dev/cu.*` and `/dev/tty.*` devices.

---

### `update_embedded_shortcuts` — Update Shortcuts

Downloads and applies the latest version of the shortcuts from GitHub without reinstalling.

```zsh
update_embedded_shortcuts
```

No parameters. Fetches the latest `.embedded_shortcuts` file and reloads it in the current shell session.

---

### `ls_edsc` — Show Shortcuts Help Menu

Prints a formatted list of all available aliases and functions defined in `.embedded_shortcuts`.

```zsh
ls_edsc
```

No parameters.

---

## Port Flag Reference

All functions that accept a `-p` flag follow the same rules:

| Input | Resolves to |
|-------|-------------|
| `-p m101` | `usbmodem101` |
| `-p s101` | `usbserial101` |
| `101` *(positional, legacy)* | `usbmodem101` |
| `usbserial101` *(positional, legacy)* | `usbserial101` |

`ed_s` uses the `/dev/tty.*` path. `ed_m` and `ed_u` use the `/dev/cu.*` path.
