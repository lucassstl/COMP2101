#this function gets the os name and version and displays 

function Get-OSInfo {
    Write-host "Operating system information"-ForegroundColor Green
    $os = Get-WmiObject -Class win32_operatingsystem
    Write-Host "Operating System: $($os.Caption)"
    Write-Host "Version: $($os.Version)"
}

#this function will get the information on the prossesor
function Get-ProcessorInfo {
    Write-Host "  "
    Write-host "Processor indormation" -ForegroundColor Green
    Write-Host "---------------------"
    $processor = Get-WmiObject -Class win32_processor
    Write-Host "Processor: $($processor.Name)"
    Write-Host "Number of Cores: $($processor.NumberOfCores)"
    Write-Host "Processor Speed: $($processor.MaxClockSpeed) MHz"

    # this is going to check if the is information on the processor cache
    # if ther is no info it will display N/A

    if ($processor.L2CacheSize -eq $null) {
        Write-Host "L1 Cache Size: N/A"
    } else {
        Write-Host "L1 Cache Size: $($processor.L2CacheSize) KB"
    }

    
    if ($processor.L2CacheSize -eq $null) {
        Write-Host "L2 Cache Size: N/A"
    } else {
        Write-Host "L2 Cache Size: $($processor.L2CacheSize) KB"
    }

    
    if ($processor.L3CacheSize -eq $null) {
        Write-Host "L3 Cache Size: N/A"
    } else {
        Write-Host "L3 Cache Size: $($processor.L3CacheSize) KB"
    }
}

Get-OSInfo
Get-ProcessorInfo

#this section will get information on the RAM of the system and display it 

$memory = Get-WmiObject Win32_PhysicalMemory
$table = @()
$totalMemory = 0
foreach ($dimm in $memory) {
    
    #this is going to fech the data on the ram and if there is no data it will display N/D 

    $vendor = $dimm.Manufacturer
    if (!$vendor) {
       $vendor = "N/D"}
    
    $description = $dimm.Caption
    if (!$description) {
       $description = "N/D"}
    
    $size = [math]::Round($dimm.Capacity / 1GB, 2)
    if (!$size) {
       $size = "N/D"}
    
    $bank = $dimm.BankLabel
    if (!$bank) {
       $bank = "N/D"}
    
    $slot = $dimm.DeviceLocator
    if (!$slot) {
       $slot = "N/D"}
    
    $totalMemory += $size
    $row = New-Object -TypeName PSObject -Property @{
        Vendor = $vendor
        Description = $description
        Size = "$size GB"
        Bank = $bank
        Slot = $slot
    }
    $table += $row
}
Write-Host "  "
Write-Host "RAM informatio" -ForegroundColor Green
Write-Host "--------------"
$table | Format-Table Vendor, Description, Size, Bank, Slot



#this section will display the information on the disk drives and display it

$disks = Get-WmiObject -Class Win32_DiskDrive | Where-Object {$_.MediaType -ne "Removable Media" -and $_.InterfaceType -ne "USB"}

$table = @()
foreach ($disk in $disks) {
    $vendor = $disk.Manufacturer
    
    $model = $disk.Model
    
    $size = [math]::Round($disk.Size / 1GB, 2)
    
    $freeSpace = [math]::Round($disk.FreeSpace / 1GB, 2)
    
    $percentFree = [math]::Round(($freeSpace / $size) * 100, 2)
    
    if (!$vendor) {
        $vendor = "N/D"}
    
    if (!$model) {
        $model = "N/D"}
    
    if (!$size) {
        $size = "N/D"}
    
    if (!$freeSpace) {
        $freeSpace = "N/D"}
    
    if (!$percentFree) {
        $percentFree = "N/D"}
    
    
    $row = New-Object -TypeName PSObject -Property @{
        Vendor = $vendor
        Model = $model
        Size = "$size GB"
        FreeSpace = "$freeSpace GB"
        PercentFree = "$percentFree %"
    }
    $table += $row
}
Write-host "  "
Write-Host "Disk drive information" -ForegroundColor Green
Write-Host "----------------------"
$table | Format-Table Vendor, Model, Size, FreeSpace, PercentFree


#this will get the information about the video cart adn display it 

$videoController = Get-WmiObject Win32_VideoController
$table = @()

foreach ($vc in $videoController) {
    $vendor = $vc.AdapterCompatibility
    $description = $vc.Description
    $resolution = "{0} x {1}" -f $vc.CurrentHorizontalResolution, $vc.CurrentVerticalResolution

    $row = New-Object -TypeName PSObject -Property @{
        Vendor = $vendor
        Description = $description
        Resolution = $resolution
    }

    $table += $row
}

#this will display the information on the enabled network adapters and display it

Write-Host "video informatio" -ForegroundColor Green
Write-Host "----------------"
$table | Format-Table Vendor, Description, Resolution

Write-Host "network configuration" -ForegroundColor Green
Write-Host "---------------------"
Get-CimInstance Win32_NetworkAdapterConfiguration | where-object ipenabled | Select-Object Description, Index, IPAddress, IPSubnet, DNSDomain, DNSServerSearchOrder
