Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function showMessageWindow {
Param
(
    [string]$Message, 
    [string]$Title, 
    [System.Windows.Forms.MessageBoxButtons]$Button, 
    [System.Windows.Forms.MessageBoxIcon]$Icon
)
    return [System.Windows.Forms.MessageBox]::Show($Message, $Title, $Button, $Icon)
}

$exeFileURL = 'https://yt-dl.org/latest/youtube-dl.exe'
$exeFilePath = '.\youtube-dl.exe'

Write-Output "youtube-dl-inputbox script started."

if (!(Test-Path $exeFilePath -PathType Leaf))
{
    showMessageWindow -Message "youtube-dl.exe file does not exist in the current folder." -Title "Error" -Button OK -Icon Error
    Write-Output "youtube-dl.exe file does not exist in the current folder."

    try
    {
	  showMessageWindow -Message "We will download the youtube-dl executable from $exeFileURL" -Title "Information" -Button OK -Icon Information
        Write-Output "We will download the youtube-dl executable from $exeFileURL"
        Invoke-WebRequest -URI $exeFileURL -OutFile $exeFilePath
    }
    catch
    {
	  showMessageWindow -Message "Error downloading automatically the youtube-dl executable from $exeFileURL" -Title "Error" -Button OK -Icon Error
        Write-Output "Error downloading automatically the youtube-dl executable from $exeFileURL"
	  showMessageWindow -Message "You can download manually the youtube-dl executable from $exeFileURL" -Title "Information" -Button OK -Icon Information
        Write-Output "You can download manually the youtube-dl executable from $exeFileURL"
    }
}

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Data Entry Form'
$form.Size = New-Object System.Drawing.Size(350,200)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(310,20)
$label.Text = 'Please enter the YouTube video URL in the space below:'
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(290,20)
$textBox.MaxLength = 92
$form.Controls.Add($textBox)

$form.Topmost = $true

$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    if (!(Test-Path $exeFilePath -PathType Leaf))
    {
        showMessageWindow -Message "Could not execute the youtube-dl.exe file." -Title "Error" -Button OK -Icon Error
	  Write-Output "Could not execute the youtube-dl.exe file."
    }
    elseif ($textBox.Text.Length -ne 0)
    {
        $youtubeVideoURL = $textBox.Text
        .\youtube-dl.exe $youtubeVideoURL
    }
    else
    {
        showMessageWindow -Message "YouTube video URL input is not valid." -Title "Error" -Button OK -Icon Error
	  Write-Output "YouTube video URL input is not valid."
    }
}
