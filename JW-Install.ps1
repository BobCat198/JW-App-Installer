


# Loading external assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$BobCat = New-Object System.Windows.Forms.Form

$Winget = New-Object System.Windows.Forms.Button
$button2 = New-Object System.Windows.Forms.Button
$button3 = New-Object System.Windows.Forms.Button
$button4 = New-Object System.Windows.Forms.Button
$statlbl = New-Object System.Windows.Forms.Label
$wingetstat = New-Object System.Windows.Forms.Label
#
# Winget
#
$Winget.Location = New-Object System.Drawing.Point(70, 41)
$Winget.Name = "Winget"
$Winget.Size = New-Object System.Drawing.Size(217, 70)
$Winget.TabIndex = 0
$Winget.Text = "Winget/Scoop"
$Winget.UseVisualStyleBackColor = $true
#
# button2
#
$button2.Location = New-Object System.Drawing.Point(70, 117)
$button2.Name = "button2"
$button2.Size = New-Object System.Drawing.Size(217, 70)
$button2.TabIndex = 1
$button2.Text = "JW Library"
$button2.UseVisualStyleBackColor = $true
#
# button3
#
$button3.Location = New-Object System.Drawing.Point(70, 193)
$button3.Name = "button3"
$button3.Size = New-Object System.Drawing.Size(217, 70)
$button3.TabIndex = 2
$button3.Text = "Zoom"
$button3.UseVisualStyleBackColor = $true
#
# button4
#
$button4.Location = New-Object System.Drawing.Point(70, 269)
$button4.Name = "button4"
$button4.Size = New-Object System.Drawing.Size(217, 70)
$button4.TabIndex = 3
$button4.Text = "OnlyM"
$button4.UseVisualStyleBackColor = $true
#
# statlbl
#
$statlbl.AutoSize = $true
$statlbl.Location = New-Object System.Drawing.Point(23, 396)
$statlbl.Name = "statlbl"
$statlbl.Size = New-Object System.Drawing.Size(122, 25)
$statlbl.TabIndex = 5
$statlbl.Text = "Winget Status"
#
# wingetstat
#
$wingetstat.AutoSize = $true
$wingetstat.Location = New-Object System.Drawing.Point(146, 400)
$wingetstat.Name = "wingetstat"
$wingetstat.Size = New-Object System.Drawing.Size(0, 25)
$wingetstat.TabIndex = 6
#
# BobCat
#
$BobCat.ClientSize = New-Object System.Drawing.Size(367, 443)
$BobCat.Controls.Add($wingetstat)
$BobCat.Controls.Add($statlbl)
$BobCat.Controls.Add($button4)
$BobCat.Controls.Add($button3)
$BobCat.Controls.Add($button2)
$BobCat.Controls.Add($Winget)
$BobCat.Name = "BobCat"
$BobCat.Text = "BobCat App Installer"

function OnLoad_BobCat
{
	
	$statlbl.Text = ""
	$cmdOutput = winget.exe -v | Out-String
	
	
	If ($cmdOutput.Contains('v1.3.0'))
	{
		$statlbl.Text = "Winget Installed"
		$statlbl.ForeColor = 'green'
		
	}
	ELSE
	{
		$statlbl.Text = "Winget Not Installed"
		$statlbl.ForeColor = 'red'
		
	}
	
}
$BobCat.Add_Load({ OnLoad_BobCat })



# Button 4 OnlyM

$button4.Add_Click({
		
		Invoke-WebRequest -Uri 'https://github.com/AntonyCorbett/OnlyM/releases/download/2.0.0.15/OnlyMSetup.exe' -OutFile $env:temp\OnlyMSetup.exe
		Start-Process $env:temp\OnlyMSetup.exe
		[System.Windows.MessageBox]::Show('Installing OnlyM')
	})
## end of onlyM Install

#winget Install and scoop


$Winget.Add_Click({
		Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vc_redist.x64.exe' -OutFile $env:temp\vc_redist.x64.exe
		
		Start-Process -NoNewWindow -FilePath "$env:temp\vc_redist.x64.exe" -ArgumentList '/q /norestart'
		
		Timeout /NoBreak 15
		
		
		irm get.scoop.sh | iex
		scoop bucket add main
		scoop install winget
		scoop update winget
		Timeout /NoBreak 15
		$cmdOutput = winget.exe -v | Out-String
		
		
		If ($cmdOutput.Contains('v1.3.0'))
		{
			$statlbl.Text = "Winget Installed Checked"
			$statlbl.ForeColor = 'green'
			
		}
	})
#end of install

$Button2.Add_Click({
		winget.exe install "JW Library" --silent --accept-package-agreements --accept-source-agreements --force
		
	})

$Button3.Add_Click({
		$button3.Text = "Installing Zoom.."
		winget.exe install Zoom.Zoom --silent --accept-package-agreements --accept-source-agreements --force
	})


# Release the Form
$BobCat.ShowDialog()
