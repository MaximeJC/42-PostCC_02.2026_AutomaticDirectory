Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

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
    }
}

class CustomForm : System.Windows.Forms.Form {
    [System.Collections.Generic.List[LabeledTextBox]]$Fields

    CustomForm([string]$prg_name, [Argument[]]$ArgsList) {
        $this.Text = $prg_name
        $this.Size = New-Object System.Drawing.Size(320, 300)
        $this.StartPosition = "CenterScreen"
        $this.Fields = [System.Collections.Generic.List[LabeledTextBox]]::new()

        $panel = New-Object System.Windows.Forms.FlowLayoutPanel
        $panel.Dock = 'Fill'
        $panel.FlowDirection = 'TopDown'
        $panel.AutoScroll = $true
        $panel.Padding = New-Object System.Windows.Forms.Padding(10)

        foreach ($arg in $ArgsList) {
            $field = [LabeledTextBox]::new($arg.Label)
            $field.TextBox.Text = $arg.DefaultValue
            $this.Fields.Add($field)
            $panel.Controls.Add($field)
        }


        $okButton = New-Object System.Windows.Forms.Button
        $okButton.Location = New-Object System.Drawing.Point(75,120)
        $okButton.Size = New-Object System.Drawing.Size(75,23)
        $okButton.Text = 'OK'
        $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $this.AcceptButton = $okButton
        $this.Controls.Add($okButton)

        $this.Controls.Add($panel)
    }

    getResult() {
        $result = $this.ShowDialog()

        ## TODO: For each required, check the length
        ## TODO: Maybe formatting the output of the form

    }
}


$prg_name = "GetGroupsExample"

#Argument( Label, isRequired, DefaultValue/PlaceHolder )
$argsData = @(
    [Argument]::new("First Name", $true, "Beaufils"),
    [Argument]::new("Last Name", $true, "Charlie")
)

$form = [CustomForm]::new($prg_name, $argsData)
$form.getResult()
