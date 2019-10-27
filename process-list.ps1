# Load required assemblies
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Windows.Forms.Application]::EnableVisualStyles()

# Start Creating Functions
Function GetProcesses{

    # Reset the columns and content of listview_Processes before adding data to it.
    $listview_Processes.Items.Clear()
    $listview_Processes.Columns.Clear()
    
    # Get a list and create an array of all running processes
    $Processes = Get-Process | Select Id,ProcessName,Handles,NPM,PM,WS,VM,CPU,Path
    
    # Compile a list of the properties stored for the first indexed process "0"
    $ProcessProperties = $Processes[0].psObject.Properties

    # Create a column in the listView for each property
    $ProcessProperties | ForEach-Object {
        $listview_Processes.Columns.Add("$($_.Name)") | Out-Null
    }

    # Looping through each object in the array, and add a row for each
    ForEach ($Process in $Processes){

        # Create a listViewItem, and assign it it's first value
        $ProcessListViewItem = New-Object System.Windows.Forms.ListViewItem($Process.Id)

        # For each properties, except for 'Id' that we've already used to create the ListViewItem,
        # find the column name, and extract the data for that property on the current object/process 
        $Process.psObject.Properties | Where {$_.Name -ne "Id"} | ForEach-Object {
            $ColumnName = $_.Name
            $ProcessListViewItem.SubItems.Add("$($Process.$ColumnName)") | Out-Null
        }

        # Add the created listViewItem to the ListView control
        # (not adding 'Out-Null' at the end of the line will result in numbers outputred to the console)
        $listview_Processes.Items.Add($ProcessListViewItem) | Out-Null

    }

    # Resize all columns of the listView to fit their contents
    $listview_Processes.AutoResizeColumns("HeaderSize")

}

Function EndProcesses{

    # Since we allowed 'MultiSelect = $true' on the listView control,
    # Compile a list in an array of selected items
    $SelectedProcesses = @($listview_Processes.SelectedIndices)

    # Find which column index has an the name 'Id' on it, for the listView control
    # We chose 'Id' because it is required by 'Stop-Process' to properly identify the process to kill.
    $IdColumnIndex = ($listview_Processes.Columns | Where {$_.Text -eq "Id"}).Index
    
    # For each object/item in the array of selected item, find which SubItem/cell of the row...
    $SelectedProcesses | ForEach-Object {
    
        # ...contains the Id of the process that is currently being "foreach'd",
        $ProcessId = ($listview_Processes.Items[$_].SubItems[$IdColumnIndex]).Text
        
        # ...and stop it.
        Stop-Process -Id $ProcessId -Confirm:$false -Force -WhatIf

        # The WhatIf switch was used to simulate the action. Remove it to use cmdlet as per normal.

    }

    # Refresh your process list, once you are done stopping them
    GetProcesses
    
}


# Drawing form and controls
$Form_HelloWorld = New-Object System.Windows.Forms.Form
    $Form_HelloWorld.Text = "Process Manager"
    $Form_HelloWorld.Size = New-Object System.Drawing.Size(832,528)
    $Form_HelloWorld.FormBorderStyle = "FixedDialog"
    $Form_HelloWorld.TopMost  = $true
    $Form_HelloWorld.MaximizeBox  = $true
    $Form_HelloWorld.MinimizeBox  = $true
    $Form_HelloWorld.ControlBox = $true
    $Form_HelloWorld.StartPosition = "CenterScreen"
    $Form_HelloWorld.Font = "Segoe UI"


# Adding a label control to Form
$label_HelloWorld = New-Object System.Windows.Forms.Label
    $label_HelloWorld.Location = New-Object System.Drawing.Size(8,8)
    $label_HelloWorld.Size = New-Object System.Drawing.Size(240,32)
    $label_HelloWorld.TextAlign = "MiddleLeft"
    $label_HelloWorld.Text = "Processes:"
        $Form_HelloWorld.Controls.Add($label_HelloWorld)


# Adding a listView control to Form, which will hold all process information
$Global:listview_Processes = New-Object System.Windows.Forms.ListView
    $listview_Processes.Location = New-Object System.Drawing.Size(8,40)
    $listview_Processes.Size = New-Object System.Drawing.Size(800,402)
    $listview_Processes.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
    [System.Windows.Forms.AnchorStyles]::Right -bor 
    [System.Windows.Forms.AnchorStyles]::Top -bor
    [System.Windows.Forms.AnchorStyles]::Left
    $listview_Processes.View = "Details"
    $listview_Processes.FullRowSelect = $true
    $listview_Processes.MultiSelect = $true
    $listview_Processes.Sorting = "None"
    $listview_Processes.AllowColumnReorder = $true
    $listview_Processes.GridLines = $true
    $listview_Processes.Add_ColumnClick({SortListView $_.Column})
        $Form_HelloWorld.Controls.Add($listview_Processes)


# Adding a button control to Form
$button_GetProcess = New-Object System.Windows.Forms.Button
    $button_GetProcess.Location = New-Object System.Drawing.Size(8,450)
    $button_GetProcess.Size = New-Object System.Drawing.Size(240,32)
    $button_GetProcess.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
    [System.Windows.Forms.AnchorStyles]::Left
    $button_GetProcess.TextAlign = "MiddleCenter"
    $button_GetProcess.Text = "Refresh Process List"
    $button_GetProcess.Add_Click({GetProcesses})
        $Form_HelloWorld.Controls.Add($button_GetProcess)


# Adding another button control to Form
$button_EndProcess = New-Object System.Windows.Forms.Button
    $button_EndProcess.Location = New-Object System.Drawing.Size(568,450)
    $button_EndProcess.Size = New-Object System.Drawing.Size(240,32)
    $button_EndProcess.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
    [System.Windows.Forms.AnchorStyles]::Right
    $button_EndProcess.TextAlign = "MiddleCenter"
    $button_EndProcess.Text = "End Selected Process(es)"
    $button_EndProcess.Add_Click({EndProcesses})
        $Form_HelloWorld.Controls.Add($button_EndProcess)



# Show form with all of its controls
$Form_HelloWorld.Add_Shown({$Form_HelloWorld.Activate();GetProcesses})
[Void] $Form_HelloWorld.ShowDialog()