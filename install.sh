#!/usr/bin/env zsh

echo "Setting up embedded terminal shortcuts..."

# 1. Check for Python 3, install if missing (required for PlatformIO)
if ! command -v python3 &> /dev/null; then
    echo "⚠️  Python 3 is not installed. Attempting to install based on your OS..."
    
    OS="$(uname -s)"
    if [ "$OS" = "Darwin" ]; then
        echo "🍎 macOS detected."
        if command -v brew &> /dev/null; then
            echo "🍺 Installing Python 3 via Homebrew..."
            brew install python
        else
            echo "❌ Homebrew is not installed. Please install Homebrew first, or install Python 3 manually."
            exit 1
        fi
    elif [ "$OS" = "Linux" ]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            case "$ID" in
                ubuntu|debian)
                    echo "🐧 Debian/Ubuntu detected. Installing Python 3 (you may be prompted for your password)..."
                    sudo apt-get update
                    # PlatformIO needs python3-venv on Debian/Ubuntu
                    sudo apt-get install -y python3 python3-venv python3-pip
                    ;;
                fedora)
                    echo "🐧 Fedora detected. Installing Python 3..."
                    sudo dnf install -y python3
                    ;;
                arch)
                    echo "🐧 Arch Linux detected. Installing Python 3..."
                    sudo pacman -S --noconfirm python
                    ;;
                *)
                    echo "❌ Unsupported Linux distribution ($ID) for auto-install. Please install Python 3 manually."
                    exit 1
                    ;;
            esac
        else
            echo "❌ Could not determine Linux distribution. Please install Python 3 manually."
            exit 1
        fi
    else
        echo "❌ Unsupported operating system ($OS). Please install Python 3 manually."
        exit 1
    fi
fi

# Double-check that Python actually installed successfully
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 installation failed. Please install it manually and run this script again."
    exit 1
else
    echo "✅ Python 3 is ready."
fi

# 2. Check if PlatformIO (pio) is installed, and install if missing
if ! command -v pio &> /dev/null; then
    echo "⚠️  PlatformIO (pio) not found. Downloading installer..."
    
    curl -fsSL -o get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
    
    echo "⚙️  Installing PlatformIO Core..."
    python3 get-platformio.py
    
    # Clean up the installer script
    rm get-platformio.py
    
    # Add PlatformIO to the PATH in .zshrc
    ZSHRC="$HOME/.zshrc"
    PIO_PATH='export PATH=$PATH:$HOME/.platformio/penv/bin'
    
    # Ensure .zshrc exists
    touch "$ZSHRC"
    
    if ! grep -qF "$PIO_PATH" "$ZSHRC"; then
        echo "\n# PlatformIO Path" >> "$ZSHRC"
        echo "$PIO_PATH" >> "$ZSHRC"
        echo "✅ Added PlatformIO to PATH in $ZSHRC."
    fi
    
    echo "✅ PlatformIO installation complete."
else
    echo "✅ PlatformIO (pio) detected."
fi

# 3. Download the shortcut file
SHORTCUT_URL="https://raw.githubusercontent.com/Michou828/terminal_shortcuts/main/.embedded_shortcuts"
DEST_FILE="$HOME/.embedded_shortcuts"

echo "⬇️  Downloading shortcuts from GitHub..."
if curl -fsSL "$SHORTCUT_URL" -o "$DEST_FILE"; then
    echo "✅ Downloaded to $DEST_FILE"
else
    echo "❌ Failed to download the shortcuts file. Check your repository URL."
    exit 1
fi

# 4. Link the shortcut file in .zshrc
ZSHRC="$HOME/.zshrc"
SOURCE_LINE="source $DEST_FILE"

# Ensure .zshrc exists
touch "$ZSHRC"

# Check if it's already linked to avoid duplicate entries
if grep -qF "$SOURCE_LINE" "$ZSHRC"; then
    echo "✅ Shortcuts are already linked in your $ZSHRC."
else
    echo "\n# Embedded Development Shortcuts" >> "$ZSHRC"
    echo "$SOURCE_LINE" >> "$ZSHRC"
    echo "✅ Added source command to $ZSHRC."
fi

echo "🎉 Installation complete!"
echo "👉 Run 'source ~/.zshrc' or open a new terminal tab to use your shortcuts and PlatformIO."
