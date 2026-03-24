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

### `ed_s` — Open Serial Monitor (screen)

Opens a serial connection to a device using `screen`.

```zsh
ed_s <port> [baud]
```

| Parameter | Required | Description |
|-----------|----------|-------------|
| `port`    | Yes      | Port identifier. Can be a number (e.g. `101`) or a full name (e.g. `usbserial101`). Numbers are automatically prefixed with `usbmodem`. |
| `baud`    | No       | Baud rate. Defaults to `115200`. |

**Examples:**
```zsh
ed_s 101          # connects to /dev/tty.usbmodem101 at 115200 baud
ed_s 101 9600     # connects at 9600 baud
ed_s usbserial101 # connects to /dev/tty.usbserial101
```

---

### `ed_m` — Open Serial Monitor (PlatformIO)

Opens a serial monitor using `pio device monitor`.

```zsh
ed_m <port> [baud]
```

| Parameter | Required | Description |
|-----------|----------|-------------|
| `port`    | Yes      | Port identifier. Same rules as `ed_s` — numbers are prefixed with `usbmodem`. Uses `/dev/cu.*` path. |
| `baud`    | No       | Baud rate. Defaults to `115200`. |

**Examples:**
```zsh
ed_m 101          # monitors /dev/cu.usbmodem101 at 115200 baud
ed_m 101 9600     # monitors at 9600 baud
ed_m usbserial101 # monitors /dev/cu.usbserial101
```

---

### `ed_u` — Upload Firmware (PlatformIO)

Runs `pio run` to build and upload firmware to a device.

```zsh
ed_u <env> [port] [target]
```

| Parameter | Required | Description |
|-----------|----------|-------------|
| `env`     | Yes      | PlatformIO environment name (from `platformio.ini`, e.g. `esp32`, `samd21`). |
| `port`    | No       | Port identifier. If omitted, PlatformIO auto-detects (useful for USB/ZeroUSB). Numbers are prefixed with `usbmodem`. |
| `target`  | No       | PlatformIO target. Defaults to `upload`. Use `uploadfs` to upload the filesystem image. |

**Examples:**
```zsh
ed_u esp32                      # auto-detect port, upload firmware
ed_u esp32 101                  # upload to /dev/cu.usbmodem101
ed_u esp32 101 uploadfs         # upload filesystem to /dev/cu.usbmodem101
ed_u samd21 usbserial101 upload # upload to /dev/cu.usbserial101
```

---

### `ls_ed` — List Serial Devices

Lists available serial devices matching a prefix under `/dev/`.

```zsh
ls_ed <type>
```

| Parameter | Required | Description |
|-----------|----------|-------------|
| `type`    | Yes      | Device prefix to filter by. Use `cu` to list `/dev/cu.*` devices or `tty` to list `/dev/tty.*` devices. |

**Examples:**
```zsh
ls_ed cu   # lists all /dev/cu.* devices
ls_ed tty  # lists all /dev/tty.* devices
```

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

## Port Identifier Reference

All functions that accept a `port` argument follow the same resolution rules:

- **Numbers only** (e.g. `101`) → expanded to `usbmodem101`
- **Mixed alphanumeric** (e.g. `usbserial101`) → used as-is

`ed_s` uses the `/dev/tty.*` path. `ed_m` and `ed_u` use the `/dev/cu.*` path.
