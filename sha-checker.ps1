# Load required assemblies
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

Function OpenFile {

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Filter = "All files (*.*)|*.*"
    If($OpenFileDialog.ShowDialog() -eq "OK"){
        $textbox_OpenFile.Text = $OpenFileDialog.FileName
    }

}

Function Get-SHA1 {

    If($textbox_OpenFile.Text -ne ""){
        
        $SHA1 = New-Object -TypeName System.Security.Cryptography.SHA1CryptoServiceProvider

        $Stream = [System.IO.File]::Open($textbox_OpenFile.Text , [System.IO.FileMode]::Open , [System.IO.FileAccess]::Read)
        $Hash = [System.BitConverter]::ToString($SHA1.ComputeHash($Stream))

        $textbox_GeneratedSHA1.Text = $Hash

    }

}

# Drawing form and controls
$Form_SHA1_hasher = New-Object System.Windows.Forms.Form
    $Form_SHA1_hasher.Text = "SHA1 Hash Checker"
    $Form_SHA1_hasher.Size = New-Object System.Drawing.Size(576,208)
    $Form_SHA1_hasher.FormBorderStyle = "FixedDialog"
    $Form_SHA1_hasher.TopMost = $false
    $Form_SHA1_hasher.MaximizeBox = $false
    $Form_SHA1_hasher.MinimizeBox = $true
    $Form_SHA1_hasher.ControlBox = $true
    $Form_SHA1_hasher.StartPosition = "CenterScreen"
    $Form_SHA1_hasher.Font = "Segoe UI"

$labelSize = New-Object System.Drawing.Size(168,20)
$buttonSize = New-Object System.Drawing.Size(96,23)
$textboxSize = New-Object System.Drawing.Size(240,20)

$Y = 8
$Yspacer = 32

$LabelTextAlign = "MiddleRight"

# adding a label to my form
$label_OpenFile = New-Object System.Windows.Forms.Label
    $label_OpenFile.Location = New-Object System.Drawing.Size(8,$Y)
    $label_OpenFile.Size = $labelSize
    $label_OpenFile.TextAlign = $LabelTextAlign
    $label_OpenFile.Text = "File to Hash"
        $Form_SHA1_hasher.Controls.Add($label_OpenFile)

$textbox_OpenFile = New-Object System.Windows.Forms.TextBox
    $textbox_OpenFile.Location = New-Object System.Drawing.Size(192,$Y)
    $textbox_OpenFile.Size = $textboxSize
        $Form_SHA1_hasher.Controls.Add($textbox_OpenFile)


# add a button
$button_OpenFile = New-Object System.Windows.Forms.Button
    $button_OpenFile.Location = New-Object System.Drawing.Size(448,$Y)
    $button_OpenFile.Size = $buttonSize
    $button_OpenFile.Text = "Browse..."
    $button_OpenFile.Add_Click({OpenFile})
        $Form_SHA1_hasher.Controls.Add($button_OpenFile)


$Y += $Yspacer


# adding a label to my form
$label_GeneratedSHA1 = New-Object System.Windows.Forms.Label
    $label_GeneratedSHA1.Location = New-Object System.Drawing.Size(8,$Y)
    $label_GeneratedSHA1.Size = $labelSize
    $label_GeneratedSHA1.TextAlign = $LabelTextAlign
    $label_GeneratedSHA1.Text = "Generated SHA1"
        $Form_SHA1_hasher.Controls.Add($label_GeneratedSHA1)

$textboxSize = New-Object System.Drawing.Size(350,20)

$textbox_GeneratedSHA1 = New-Object System.Windows.Forms.TextBox
    $textbox_GeneratedSHA1.Location = New-Object System.Drawing.Size(192,$Y)
    $textbox_GeneratedSHA1.Size = $textboxSize
        $Form_SHA1_hasher.Controls.Add($textbox_GeneratedSHA1)


$Y += $Yspacer


# adding a label to my form
$label_ExpectedSHA1 = New-Object System.Windows.Forms.Label
    $label_ExpectedSHA1.Location = New-Object System.Drawing.Size(8,$Y)
    $label_ExpectedSHA1.Size = $labelSize
    $label_ExpectedSHA1.TextAlign = $LabelTextAlign
    $label_ExpectedSHA1.Text = "Expected SHA1"
        $Form_SHA1_hasher.Controls.Add($label_ExpectedSHA1)

$textboxSize = New-Object System.Drawing.Size(350,20)

$textbox_ExpectedSHA1 = New-Object System.Windows.Forms.MaskedTextBox
    $textbox_ExpectedSHA1.Location = New-Object System.Drawing.Size(192,$Y)
    $textbox_ExpectedSHA1.Size = $textboxSize
    $textbox_ExpectedSHA1.Mask = "AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA"
        $Form_SHA1_hasher.Controls.Add($textbox_ExpectedSHA1)


$Y += $Yspacer
$Y += $Yspacer


# add a button
$button_GeneratedSHA1 = New-Object System.Windows.Forms.Button
    $button_GeneratedSHA1.Location = New-Object System.Drawing.Size(448,$Y)
    $button_GeneratedSHA1.Size = $buttonSize
    $button_GeneratedSHA1.Text = "Generate SHA1"
    $button_GeneratedSHA1.Add_Click({Get-SHA1})
        $Form_SHA1_hasher.Controls.Add($button_GeneratedSHA1)


# show form
$Form_SHA1_hasher.Add_Shown({$Form_SHA1_hasher.Activate()})
[void] $Form_SHA1_hasher.ShowDialog()