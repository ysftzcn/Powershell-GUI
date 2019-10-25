<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Untitled
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

Function Get-FixedDisk {
    [CmdletBinding()]
    # This param() block indicates the start of parameters declaration
    param (
        <# 
            This parameter accepts the name of the target computer.
            It is also set to mandatory so that the function does not execute without specifying the value.
        #>
        [Parameter(Mandatory)]
        [string]$Computer
    )
    <#
        WMI query command which gets the list of all logical disks and saves the results to a variable named $DiskInfo
    #>
    $DiskInfo = Get-WmiObject Win32_LogicalDisk -ComputerName $Computer -Filter 'DriveType=3'
   $DiskInfo
}

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '685,340'
$Form.text                       = "Form"
$Form.TopMost                    = $false

$btnQuery                        = New-Object system.Windows.Forms.Button
$btnQuery.text                   = "button"
$btnQuery.width                  = 113
$btnQuery.height                 = 30
$btnQuery.location               = New-Object System.Drawing.Point(544,278)
$btnQuery.Font                   = 'Microsoft Sans Serif,10'

$txtResults                      = New-Object system.Windows.Forms.ListView
$txtResults.text                 = "listView"
$txtResults.width                = 637
$txtResults.height               = 237
$txtResults.location             = New-Object System.Drawing.Point(22,25)

$Form.controls.AddRange(@($btnQuery,$txtResults,$Computer))



$btnQuery.Add_Click( {
    #clear the result box
    $txtResults.Text = ""
        if ($result = Get-FixedDisk -Computer $Computer.Text) {
            foreach ($item in $result) {
                $txtResults.Text = $txtResults.Text + "DeviceID: $($item.DeviceID)`n"
                $txtResults.Text = $txtResults.Text + "VolumeName: $($item.VolumeName)`n"
                $txtResults.Text = $txtResults.Text + "FreeSpace: $($item.FreeSpace)`n"
                $txtResults.Text = $txtResults.Text + "Size: $($item.Size)`n`n"
            }
        }       
    })
    
[void]$Form.ShowDialog()