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
$title.text = "Searching new Users..."
# Make sure the label is sized the height and length of the content
$title.autosize = $true
# Define the minial width and height (not nessary with autosize true
$title.width = 25
$title.height = 10
# Position the element
$title.location = New-Object System.Drawing.Point(20,20)
# Define the font type and size
$title.Font = 'Microsoft Sans Serif,13'

# Add the elements to the form
$localform.controls.AddRange(@($title))

[void]$localform.ShowDialog()