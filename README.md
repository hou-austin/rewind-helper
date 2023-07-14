# Rewind Helper

Rewind Helper is a launchd script designed to manage file storage on your primary drive by moving older files to a secondary drive for the program [Rewind](https://www.rewind.ai). This ensures optimal performance when accessing recent files, saves storage space on the primary drive, and conserves power by minimizing usage of the external storage. In particular, I noticed better performance for the Ask Rewind feature versus storing all data on an external drive. My storage solution was a SanDisk Extreme Pro MicroSD in a BaseQi 420A flush adapter in a MacBook Pro M2 Max.

With my data, it saved about 78% of space on the internal disk. A significant portion has been moved to the external drive.

## Disclaimer

- There is no guarantee that this will continue to work when Rewind is updated (tested on v1.2219).
- There is also no guarantee that this will not corrupt your Rewind data: **Backups are highly advised**.

## Files

The project consists of three main files:

1. **rewind_helper.c**: A C program that serves as an interface to the shell script `rewind_helper.sh`.
2. **rewind_helper.sh**: The core script that implements the functionality of moving older files from the primary location to the secondary location and deleting unlinked folders from the secondary location.
3. **com.austinhou.rewindhelper.plist**: The launchd configuration file which runs `rewind_helper` once every day, and redirects stdout and stderr to `script.log` and `error.log`, respectively.

## Requirements

- C compiler (for example, gcc)
- zsh shell

## Usage

1. **You will need to modify the `LOCATION_B` path in `rewind_helper.sh` to a desired path**
2. Run the `install.sh` script:

   ```bash
   ./install.sh
   ```

The script is now installed and will automatically run once every day, moving files older than 14 days from the primary location (`$HOME/Library/Application Support/com.memoryvault.MemoryVault/chunks` and `$HOME/Library/Application Support/com.memoryvault.MemoryVault/snippets`) to the secondary location (you need to specify this).

## Logs

The script's output and errors are logged to the following files:

- Standard output: `/var/log/rewind_helper/script.log`
- Standard error: `/var/log/rewind_helper/error.log`

You can view these files to monitor the script's operation and troubleshoot any issues.

## Customization

You may modify the paths and parameters in the `rewind_helper.sh` file to suit your needs. For instance, you can adjust the age threshold for moving files, or change the locations where files are moved from and to.

## Uninstallation

To uninstall the script, simply run the `uninstall.sh` script:

```bash
./uninstall.sh
```

The script and related files will be removed, and the launchd job will be unloaded.

## Permissions

You may need to run the following:

```bash
chmod +x ./install.sh
chmod +x ./uninstall.sh
```

## Improvements

- It might be worth looking into the performance behavior of the SQL db on the external disk. It has the second/third largest impact - below chunks and snippets. If the performance is satisfactory on a MicroSD card, it may be worthwhile to move this file too.
