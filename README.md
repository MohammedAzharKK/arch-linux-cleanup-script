# Arch Linux Cleanup Script

This script is designed to help clean up unnecessary files and free up space on Arch Linux systems. It performs several cleanup tasks, including clearing cache, removing orphaned packages, and deleting temporary files.

## Features

- Clears Pacman cache
- Removes orphaned packages
- Cleans large log files
- Clears systemd journal logs
- Deletes temporary files in `/tmp`
- Clears user cache and old thumbnails
- Optionally moves the script to `/usr/local/bin` for easy access

## Usage

### Prerequisites

- **Pacman**: This script is intended for use on Arch Linux and assumes that `pacman` is installed.
- **Sudo Access**: You will need sudo privileges to execute some commands in the script.

### Steps to Use

1. **Clone the Repository**:  
   Open your terminal and type the following command to create a local copy of the repository on your machine:
   ```bash
   git clone https://github.com/yourusername/arch-linux-cleanup-script.git
Navigate to the Directory:
After cloning the repository, change your current directory to the one containing the script:

bash
Copy code
cd arch-linux-cleanup-script
Make the Script Executable:
Grant execute permissions to the cleanup.sh script by typing:

bash
chmod +x cleanup.sh

Run the Script:
Execute the script with the following command:
bash
./cleanup.sh
The script will perform various cleanup operations as specified.

Optional: Move Script for Easy Access
When you run the script for the first time, it will prompt you to move itself to /usr/local/bin for easy access. If you choose to do so, you can run the script from anywhere using:

bash
cleanup.sh
