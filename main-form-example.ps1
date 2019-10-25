# Init Powershell Gui
Add-Type -AssemblyName System.Windows.Forms


# Create new form
$localform = New-Object System.Windows.Forms.Form

# Define the size, title and backgorund color
$localform.ClientSize = '500,300'
$localform.text = "Yusuf TEZCAN - Powershell GUI"
$localform.backcolor = "#ffffff"


# Create a Title for our form. We will use a label for it.
$title = New-Object System.windows.Forms.Label
# The content of laber
$title.text = "Searching disabled Users..."
# Make sure the label is sized the height and length of the content
$title.autosize = $true
# Define the minial width and height (not nessary with autosize true
$title.width = 25
$title.height = 10
# Position the element
$title.location = New-Object System.Drawing.Point(20,20)
# Define the font type and size
$title.Font = 'Microsoft Sans Serif,13'

# Add a Button Object
$SearchUsers                   = New-Object system.Windows.Forms.Button
$SearchUsers.BackColor         = "#a4ba67"
$SearchUsers.text              = "Search"
$SearchUsers.width             = 150
$SearchUsers.height            = 30
$SearchUsers.location          = New-Object System.Drawing.Point(340,250)
$SearchUsers.Font              = 'Microsoft Sans Serif,10'
$SearchUsers.ForeColor         = "#ffffff"

# Add a cancel button
$cancelBtn                       = New-Object system.Windows.Forms.Button
$cancelBtn.BackColor             = "#ffffff"
$cancelBtn.text                  = "Cancel"
$cancelBtn.width                 = 90
$cancelBtn.height                = 30
$cancelBtn.location              = New-Object System.Drawing.Point(210,250)
$cancelBtn.Font                  = 'Microsoft Sans Serif,10'
$cancelBtn.ForeColor             = "#000"
$cancelBtn.DialogResult          = [System.Windows.Forms.DialogResult]::Cancel
$localform.CancelButton   = $cancelBtn

function searchuser {
    Get-ADUser -Filter * -Properties * | Select-Object Name, SamAccountName, EmailAddress, Enabled | Where-Object EmailAddress -Like "" |Where-Object Enabled -Like *False*
}

$SearchUsers.Add_Click({searchuser})

# Add the elements to the form
$localform.controls.AddRange(@($title,$SearchUsers,$cancelBtn))

$result = $localform.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::Cancel)
{
    write-output 'Process Cancelled'
}

