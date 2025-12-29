# Switch-Omo-Config

Interactive CLI tool to switch between [oh-my-opencode](https://github.com/code-yeongyu/oh-my-opencode) configuration profiles.

![Demo](https://img.shields.io/badge/macOS-compatible-brightgreen) ![Shell](https://img.shields.io/badge/shell-bash-blue)

## What it does

Quickly switch between different `oh-my-opencode` configurations without manually copying files. Useful when you have multiple profiles for different AI providers (ChatGPT, Google, Copilot, etc.).

## Prerequisites

- macOS (uses `md5` for file comparison)
- [oh-my-opencode](https://github.com/code-yeongyu/oh-my-opencode) installed
- Multiple config profiles named `oh-my-opencode-*.json` in `~/.config/opencode/`

## Installation

### Option 1: Direct download

```bash
curl -o ~/.config/opencode/switch-omo-config.sh \
  https://raw.githubusercontent.com/AnPod/Switch-Omo-Config/main/switch-omo-config.sh
chmod +x ~/.config/opencode/switch-omo-config.sh
```

### Option 2: Manual

```bash
# Copy the script to your opencode config directory
cp switch-omo-config.sh ~/.config/opencode/
chmod +x ~/.config/opencode/switch-omo-config.sh
```

### Add shell alias (recommended)

```bash
# For zsh
echo 'alias omo-switch="~/.config/opencode/switch-omo-config.sh"' >> ~/.zshrc
source ~/.zshrc

# For bash
echo 'alias omo-switch="~/.config/opencode/switch-omo-config.sh"' >> ~/.bashrc
source ~/.bashrc
```

## Usage

```bash
# Run directly
~/.config/opencode/switch-omo-config.sh

# Or with alias
omo-switch
```

### Controls

| Key | Action |
|-----|--------|
| `↑` or `k` | Move selection up |
| `↓` or `j` | Move selection down |
| `Enter` | Apply selected config |
| `q` | Quit without changes |

### Example output

```
Switch oh-my-opencode Configuration
Use arrow keys to navigate, Enter to select, q to quit

> oh-my-opencode-ChatGPT.json
  oh-my-opencode-baseline.json
  oh-my-opencode-copilot.json
  oh-my-opencode-google.json (active)
  oh-my-opencode-minimax.json
```

## How it works

1. Scans `~/.config/opencode/` for files matching `oh-my-opencode-*.json`
2. Compares file hashes to identify which profile is currently active
3. On selection, copies the chosen file to `oh-my-opencode.json`

## Config file structure

```
~/.config/opencode/
├── opencode.json              # Main OpenCode config
├── oh-my-opencode.json        # Active oh-my-opencode config (managed by this tool)
├── oh-my-opencode-ChatGPT.json
├── oh-my-opencode-google.json
├── oh-my-opencode-copilot.json
└── oh-my-opencode-baseline.json
```

## License

MIT
