Add-Type -AssemblyName PresentationFramework

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

#where is the XAML file?
$xamlFile = "C:\My Folders\Github\Powershell-GUI\MainWindow.xaml"

#create window
$inputXML = Get-Content $xamlFile -Raw
$inputXML = $inputXML -replace 'mc:Ignorable="d"', '' -replace "x:N", 'N' -replace '^<Win.*', '<Window'
[xml]$xaml = $inputXML
#Read XAML

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
try {
    $window = [Windows.Markup.XamlReader]::Load( $reader )
}
catch {
    Write-Warning $_.Exception
    throw
}

#Create variables based on form control names.
#Variable will be named as 'var_<control name>'

$xaml.SelectNodes("//*[@Name]") | ForEach-Object {
    #"trying item $($_.Name)";
    try {
        Set-Variable -Name "var_$($_.Name)" -Value $window.FindName($_.Name) -ErrorAction Stop
    } catch {
        throw
   }
}

Get-Variable var_*

$var_btnQuery.Add_Click( {
   #clear the result box
   $var_txtResults.Text = ""
       if ($result = Get-FixedDisk -Computer $var_txtComputer.Text) {
           foreach ($item in $result) {
               $var_txtResults.Text = $var_txtResults.Text + "DeviceID: $($item.DeviceID)`n"
               $var_txtResults.Text = $var_txtResults.Text + "VolumeName: $($item.VolumeName)`n"
               $var_txtResults.Text = $var_txtResults.Text + "FreeSpace: $($item.FreeSpace)`n"
               $var_txtResults.Text = $var_txtResults.Text + "Size: $($item.Size)`n`n"
           }
       }       
   })

$var_txtComputer.Text = $env:COMPUTERNAME
$Null = $window.ShowDialog()