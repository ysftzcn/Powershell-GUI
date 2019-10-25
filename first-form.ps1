# Init Powershell Gui
Add-Type -AssemblyName System.Windows.Forms

# Create new form
$localform = New-Object System.Windows.Forms.Form

# Define the size, title and backgorund color
$localform.ClientSize = '500,300'
$localform.text = "Yusuf TEZCAN - Powershell GUI"
$localform.backcolor = "#050000"


# Display the form
[void]$localform.ShowDialog()