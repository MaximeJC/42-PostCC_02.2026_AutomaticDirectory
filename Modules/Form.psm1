

class Argument {
    [string]$Label
    [bool]$isRequired
    [string]$DefaultValue

    Argument([string]$Label, [bool]$isRequired, [string]$DefaultValue = "") {
        $this.Label = $Label
        $this.isRequired = $isRequired
        $this.DefaultValue = $DefaultValue
    }
}

function Show-ErrorMessage {
    param([string]$message)
    [System.Windows.Forms.MessageBox]::Show(
        $message,
        'Error',
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
}

class LabeledTextBox : System.Windows.Forms.Panel {
    [System.Windows.Forms.Label]$Label
    [System.Windows.Forms.TextBox]$TextBox

    LabeledTextBox([string]$labelText) {
        $this.Size = New-Object System.Drawing.Size(280, 50)

        $this.Label = New-Object System.Windows.Forms.Label
        $this.Label.Text = $labelText
        $this.Label.AutoSize = $true
        $this.Label.Location = New-Object System.Drawing.Point(0, 0)

        $this.TextBox = New-Object System.Windows.Forms.TextBox
        $this.TextBox.Location = New-Object System.Drawing.Point(0, 20)
        $this.TextBox.Size = New-Object System.Drawing.Size(260, 20)

        $this.Controls.Add($this.Label)
        $this.Controls.Add($this.TextBox)
    }}

class CustomForm : System.Windows.Forms.Form {
    [System.Collections.Generic.List[LabeledTextBox]]$Fields
    [Argument[]]$ArgsList

    CustomForm([string]$prg_name, [Argument[]]$ArgsList) {
        $this.ArgsList = $ArgsList
        $this.Text = $prg_name
        $this.Size = New-Object System.Drawing.Size(320, 350)
        $this.StartPosition = "CenterScreen"
        $this.Fields = [System.Collections.Generic.List[LabeledTextBox]]::new()

        $buttonPanel = New-Object System.Windows.Forms.Panel
        $buttonPanel.Height = 60
        $buttonPanel.Dock = 'Bottom'

        $okButton = New-Object System.Windows.Forms.Button
        $okButton.Size = New-Object System.Drawing.Size(120, 30)
        $okButton.Text = 'OK'
        $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    
        $buttonLeft = [int](([int]$this.ClientSize.Width - [int]$okButton.Width) / 2) ## center the button
        $okButton.Location = New-Object System.Drawing.Point($buttonLeft, 15)
    
        $this.AcceptButton = $okButton
        $buttonPanel.Controls.Add($okButton)


        $panel = New-Object System.Windows.Forms.FlowLayoutPanel
        $panel.Dock = 'Fill'
        $panel.FlowDirection = 'TopDown'
        $panel.AutoScroll = $true
        $panel.Padding = New-Object System.Windows.Forms.Padding(10)

        ## add all inputs from argslist
        foreach ($arg in $ArgsList) {
            $field = [LabeledTextBox]::new($arg.Label)
            $field.TextBox.Text = $arg.DefaultValue
            $this.Fields.Add($field)
            $panel.Controls.Add($field)
        }

        $this.Controls.Add($buttonPanel)
        $this.Controls.Add($panel)
    }


    [void]askInput() {
        $result = $this.ShowDialog()

        ## checking for canceled form
        if ($result -ne 1) {
            $error_message = "Error: Form canceled."
            throw ($error_message)
        }

        ## checking for a blank REQUIRED field
        for ($i = 0; $i -lt $this.ArgsList.Length; $i++) { 
            if ($this.ArgsList[$i].isRequired -and 
                $this.Fields[$i].TextBox.Text.length -eq 0) {                
                $error_message = "Error: Field " + $this.ArgsList[$i].Label + " is required."
                throw ($error_message)
            }
        }
    }

    [string] getFormValue([string]$Label) {
        for ($i = 0; $i -lt $this.ArgsList.Length; $i++) { 
            if ($this.ArgsList[$i].Label -eq $Label) {                
                return ($this.Fields[$i].TextBox.Text)
            }
        }
        throw("Error: "" $Label "" doesn't exists in the arguments")
    }
}



## ==================== USAGE ====================

function form_usage_example() {
    ## import the module
    ## Import-Module 'this-file.psm1'


    # program name
    $prg_name = "GetGroupsExample"


    #Argument: Label, isRequired, DefaultValue
    $argsData = @(
        [Argument]::new("Last Name", $true, "Charlie"), 
        [Argument]::new("First Name", $true, "Beaufils")
    )

    try {
        $form = [CustomForm]::new($prg_name, $argsData)
    
        # displays the form
        $form.askInput()

                                   # get a value by its field's name
        Write-Host "Last Name: "   $form.getFormValue("Last Name")
        Write-Host "First Name: "  $form.getFormValue("First Name")
        Write-Host "Test throw: "  $form.getFormValue("Test_throw")

    }
    catch {
        Write-Host "$_" ## stdout
        Show-ErrorMessage("$_") ## windows gui error message
        exit(1)
    }

}

