#!/bin/bash

# Check if the script is already in /usr/local/bin
if [[ $(dirname "$(realpath "$0")") != "/usr/local/bin" ]]; then
    echo "Do you want to move this script to /usr/local/bin for easy access? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        # Move the script to /usr/local/bin with sudo permissions
        script_name=$(basename "$0")
        sudo cp "$0" /usr/local/bin/"$script_name"
        sudo chmod +x /usr/local/bin/"$script_name"
        echo "Script moved to /usr/local/bin. You can now run it from anywhere using the command: $script_name"
        exit 0
    fi
fi

echo "Starting system cleanup on Arch Linux..."

# Display initial disk usage
initial_space=$(df --output=used / | tail -n 1)
echo "Initial disk usage:"
df -h /

# 1. Clear Pacman Cache (keeps only the last 3 versions of each package)
echo "Clearing pacman cache..."
paccache -rk3

# 2. Remove orphaned packages (dependencies no longer required by any package)
echo "Removing orphaned packages..."
sudo pacman -Rns $(pacman -Qdtq) --noconfirm

# 3. Clear large log files in /var/log
echo "Clearing large log files..."
sudo find /var/log -type f -size +10M -exec truncate -s 0 {} \;

# 4. Clear systemd journal logs (keeping logs from the last 2 weeks)
echo "Clearing systemd journal logs..."
sudo journalctl --vacuum-time=2weeks

# 5. Clear temporary files in /tmp
echo "Clearing temporary files in /tmp..."
sudo rm -rf /tmp/*

# 6. Clear user cache
echo "Clearing user cache..."
rm -rf ~/.cache/*

# 7. Clear old thumbnails
echo "Clearing old thumbnails..."
rm -rf ~/.cache/thumbnails/*

# 8. Clear old icon cache and other leftover cache files in /var/tmp
echo "Clearing leftover cache files in /var/tmp..."
sudo rm -rf /var/tmp/*

# 9. Remove unused packages via Flatpak if Pacman isn't available
if command -v pacman &> /dev/null; then
    echo "Removing unnecessary packages with pacman..."
    sudo pacman -Sc --noconfirm
else
    if command -v flatpak &> /dev/null; then
        echo "Removing unused Flatpak packages..."
        flatpak uninstall --unused -y
    fi
fi

# 10. Clear package build cache in ~/.cache (if you use AUR helpers like yay or paru)
if command -v yay &> /dev/null; then
    echo "Clearing yay cache..."
    yay -Scc --noconfirm
elif command -v paru &> /dev/null; then
    echo "Clearing paru cache..."
    paru -Scc --noconfirm
fi

# 11. Remove older kernel versions if they are not needed (be cautious with this step)
echo "Removing old kernels..."
sudo pacman -Qdt | grep linux | xargs sudo pacman -Rns --noconfirm

# Display final disk usage
final_space=$(df --output=used / | tail -n 1)
echo "Final disk usage:"
df -h /

# Calculate space cleared
space_cleared=$((initial_space - final_space))
echo "Total space cleared: $(echo "scale=2; $space_cleared/1024" | bc) MB"

echo "System cleanup completed."

