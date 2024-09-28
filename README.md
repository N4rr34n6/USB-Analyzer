# USB-Analyzer

USB-Analyzer is an innovative PowerShell script designed to streamline the analysis of Windows setupapi logs. It efficiently extracts detailed information about USB device events, including installations and uninstallations, while providing users with a clear and comprehensive overview of USB activity. This powerful tool is essential for system administrators, cybersecurity professionals, and forensic investigators who need to monitor and manage USB device interactions on Windows systems.

## Unique Selling Points

- **Comprehensive USB Monitoring**: USB-Analyzer meticulously analyzes all relevant entries in the setupapi logs, ensuring no critical information is overlooked. This thoroughness is crucial for maintaining system integrity and security.

- **Intuitive Report Generation**: The script automatically generates a detailed CSV report summarizing USB events. This feature not only saves time but also enhances clarity, allowing for easy interpretation of data and quick decision-making.

- **Real-Time Insights**: By summarizing installation and uninstallation events, USB-Analyzer provides real-time insights into USB device interactions, enabling proactive management of USB security policies.

- **User-Friendly Command-Line Interface**: Designed for ease of use, USB-Analyzer allows users to execute the script effortlessly within PowerShell, making it accessible to both novice and experienced users.

- **Flexible and Customizable**: Users can easily modify the log file path and tailor the output to meet specific needs. This flexibility makes USB-Analyzer a versatile tool suitable for various environments.

## Key Features

- **USB Event Extraction**: Filters logs to display only USB-related events, enhancing focus on relevant data.
- **CSV Export**: Results are exported to a CSV file for easy analysis and reporting.
- **Event Statistics**: Summarizes USB activity by counting installations, uninstallations, and unique devices, providing quick insights into USB usage.

## Installation

To use USB-Analyzer, a Windows operating system with PowerShell is required. No additional dependencies are needed.

1. Download the script `USB-Analyzer.ps1`.
2. Open PowerShell with administrative privileges.
3. Navigate to the location of the script.
4. Execute the script with the following command:
   ```powershell
   .\USB-Analyzer.ps1
   ```

## Prerequisites

- Windows 10 or later versions.
- Appropriate permissions to access log files in the `C:\Windows\inf` directory.

## Usage

Once the script runs, it analyzes the configuration log files and generates a `USB_Events.csv` file in the same location where the script is executed. The CSV file contains the following fields:

- **Action**: The action performed (installation or uninstallation).
- **Device**: Information about the USB device.
- **Timestamp**: Timestamp of the action.

## Additional Configuration

No additional configurations are required, but users may modify the log file path in the `$logPath` variable if necessary.

## Technical Details

The script utilizes the following logic for analysis:

1. **Information Extraction**: The `Extract-Info` function processes each line of the log file to identify relevant actions and USB devices.
2. **Results Storage**: Identified events are stored in a collection that is sorted chronologically before export.
3. **Data Export**: The results are filtered to include only those events that have a timestamp, action, and device before being exported to a CSV file.

## License

This script is provided under the GNU Affero General Public License v3.0. You can find the full license text in the [LICENSE](LICENSE) file.
