# Define the path to the setupapi logs
$logPath = "$env:SystemRoot\inf\setupapi.dev*.log"

# Function to extract information from a line
function Extract-Info {
    param (
        [string]$line  # The line of text to process
    )
    # If the line matches the expected pattern, extract the action and device info
    if ($line -match '>>>\s+\[(.*?)\]') {
        $action = $matches[1]
        # Check if the action is related to USB devices
        if ($action -match '(Device Install|Install Device|Delete Device|Uninstall Device).*?(USB|USBSTOR|VID_)') {
            $deviceInfo = $action -replace '^.*?(\bUSB.*|USBSTOR.*|VID_.*)', '$1'
            return @{
                Action = $action -replace ' - .*$', ''  # Remove unnecessary info
                Device = $deviceInfo
                Timestamp = $null  # Not available in this case
            }
        }
    }
    # If the line indicates a section start, extract the timestamp
    elseif ($line -match '>>>\s+Section start (.*)') {
        return @{
            Timestamp = $matches[1]
        }
    }
    # Return null if no relevant information was found
    return $null
}

# Get all setupapi logs in the specified path
$logFiles = Get-ChildItem -Path $logPath

# Array to store the results
$results = @()

foreach ($file in $logFiles) {
    $content = Get-Content $file  # Read the file content

    $currentEvent = $null  # Initialize current event variable

    foreach ($line in $content) {
        $info = Extract-Info -line $line  # Process each line

        if ($info) {
            # If the info contains an action, update the current event
            if ($info.ContainsKey('Action')) {
                if ($currentEvent -and $currentEvent.Timestamp) {
                    $results += [PSCustomObject]$currentEvent  # Add current event to results array
                }
                $currentEvent = $info  # Update current event with new info
            }
            # If the info contains a timestamp and we have an existing current event, update its timestamp
            elseif ($info.ContainsKey('Timestamp') -and $currentEvent) {
                $currentEvent.Timestamp = $info.Timestamp
            }
        }
    }

    # Add the last event to the results array if it exists and has a timestamp
    if ($currentEvent -and $currentEvent.Timestamp) {
        $results += [PSCustomObject]$currentEvent
    }
}

# Sort the results by date
$results = $results | Sort-Object { [DateTime]$_.Timestamp }

# Create a CSV file with the results
$csvPath = "USB_Events.csv"
# Only export events that have a timestamp, action and device info
$results | Where-Object { $_.Timestamp -and $_.Action -and $_.Device } | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

# Generate summary statistics
$installCount = ($results | Where-Object { $_.Action -match 'Install' }).Count  # Count of install events
$uninstallCount = ($results | Where-Object { $_.Action -match 'Delete|Uninstall' }).Count  # Count of uninstall events
$uniqueDevices = ($results | Where-Object { $_.Device } | Select-Object -Property Device -Unique).Count  # Number of unique devices detected

Write-Output "Summary of USB events:"
Write-Output "  Installations: $installCount"
Write-Output "  Uninstallations: $uninstallCount"
Write-Output "  Unique devices detected: $uniqueDevices"
Write-Output "The detailed results have been saved to: $csvPath"

# Display the first 10 lines of the CSV file for verification
Write-Output "`nFirst 10 lines of the generated CSV:"
Get-Content $csvPath -Head 10

# Display the top 5 most frequent USB devices
Write-Output "`nTop 5 USB devices by frequency:"
$results | Where-Object { $_.Device } | Group-Object Device | Sort-Object Count -Descending | Select-Object -First 5 | ForEach-Object {
    Write-Output "  $($_.Name): $($_.Count) events"
}
