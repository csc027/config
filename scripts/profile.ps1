[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'This script requires the use of global variables.')]
param(
)

$ProfileDirectory = Split-Path -Path $PROFILE -Parent;

$SolarizedDefaultFile = switch ($Host.UI.RawUI.BackgroundColor.ToString()) {
	'White' { 'Set-SolarizedLightColorDefaults.ps1' }
	'Black' { 'Set-SolarizedDarkColorDefaults.ps1' }
	default { 'Set-SolarizedDarkColorDefaults.ps1' }
};

$SolarizedDefaultPath = Join-Path -Path $ProfileDirectory -ChildPath $SolarizedDefaultFile;
if ((Test-Path -Path $SolarizedDefaultPath) -and -not (Test-Path -Path 'Env:\WT_SESSION')) {
	. $SolarizedDefaultPath;
}

$Modules = @(
	@{
		'Name' = Join-Path -Path $HOME -ChildPath '.aliases.psm1';
		'ArgumentList' = @();
		'Force' = $true
	}, @{
		'Name' = 'posh-git';
		'ArgumentList' = @($false, $false, $true);
		'Force' = $true
	}
);

if ($Host.UI.SupportsVirtualTerminal) {
	$Modules += @(
		@{
			'Name' = 'DirColors';
			'ArgumentList' = @();
			'Force' = $true
		}
	);
}

foreach ($Module in $Modules) {
	Import-Module @Module;
}

if ((Get-Command -Name 'Get-PSReadLineOption' -ErrorAction SilentlyContinue) -and (Get-PSReadLineOption | Select-Object -ExpandProperty EditMode)) {
	Set-PSReadLineOption -EditMode 'Windows';
}

if (Get-Command -Name 'Update-DirColors' -ErrorAction SilentlyContinue) {
	Update-DirColors -Path (Join-Path -Path $HOME -ChildPath '.dircolors');
}

if ($env:WT_SESSION) {
	$script:RightSeparator = ' ❭ ';
	$script:LeftSeparator = ' ❬ ';
} else {
	$script:RightSeparator = ' > ';
	$script:LeftSeparator = ' < ';
}

function prompt {
	$LastCommandState = $?;

	Write-Host -Object '┌ ' -ForegroundColor 'Gray' -NoNewline;
	if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
		Write-Host -Object "Admin$script:RightSeparator" -ForegroundColor 'Red' -NoNewline;
	} elseif ($PSDebugContext) {
		Write-Host -Object "Debug$script:RightSeparator" -ForegroundColor 'Yellow' -NoNewline;
	}

	$Machine = if ($IsLinux) { (hostname); } else { $env:COMPUTERNAME; }
	Write-Host -Object "$Machine$script:RightSeparator" -ForegroundColor 'Magenta' -NoNewline;
	Write-Host -Object "$($env:USERNAME)$script:RightSeparator" -ForegroundColor 'Green' -NoNewline;
	Write-Host -Object "$(Get-PromptPath)$script:RightSeparator" -ForegroundColor 'Blue' -NoNewline;
	if ($Status = Get-GitStatus -Force) {
		Write-Host -Object (Write-GitBranchName -Status $Status -NoLeadingSpace) -NoNewline;
		Write-Host -Object $script:RightSeparator -ForegroundColor 'Cyan' -NoNewline;
		if ($BranchStatus = Write-GitBranchStatus -Status $Status -NoLeadingSpace) {
			Write-Host -Object $BranchStatus -NoNewline;
			Write-Host -Object $script:RightSeparator -ForegroundColor (Get-GitBranchStatusColor).ForegroundColor -NoNewline;
		}
		if ($Status.HasIndex) {
			Write-Host -Object (Write-GitIndexStatus -Status $Status -NoLeadingSpace) -NoNewline;
			Write-Host -Object $script:RightSeparator -ForegroundColor 'Green' -NoNewline;
		}
		if ($Status.HasWorking) {
			Write-Host -Object "$(Write-GitWorkingDirStatus -Status $Status -NoLeadingSpace)$(Write-GitWorkingDirStatusSummary -Status $Status -NoLeadingSpace)" -NoNewline;
			Write-Host -Object $script:RightSeparator -ForegroundColor 'DarkRed' -NoNewline;
		}
	}

	$RightWidth = if (-not $LastCommandState) { 36; } else { 32; }
	$BlankWidth = $Host.UI.RawUI.WindowSize.Width - $Host.UI.RawUI.CursorPosition.X - $RightWidth;
	if ($BlankWidth -gt 0) {
		Write-Host (' ' * $BlankWidth) -NoNewline;
		if (-not $LastCommandState) {
			Write-Host -Object "$script:LeftSeparator!" -ForegroundColor 'Red' -NoNewline;
		}
		$Date = Get-Date;
		Write-Host -Object "$script:LeftSeparator$(Get-Date -Date $Date -Format 'MM/dd/yyyy')" -ForegroundColor 'DarkYellow' -NoNewline;
		Write-Host -Object "$script:LeftSeparator$(Get-Date -Date $Date -Format 'hh:mm tt')" -ForegroundColor 'DarkMagenta' -NoNewline;
		Write-Host -Object "$script:LeftSeparator$(Get-Date -Date $Date -Format 'ss.ff')" -ForegroundColor 'Gray' -NoNewline;
	}

	Write-Host -Object "`n└─▶" -NoNewline;
	return ' ';
}

if ($global:GitPromptSettings) {
	if ($global:GitPromptSettings.PSObject.Properties.Name -contains 'DefaultPromptPrefix') {
		$global:GitPromptSettings.DefaultPromptPrefix = $null;
	}
	if ($global:GitPromptSettings.PSObject.Properties.Name -contains 'BeforePath') {
		$global:GitPromptSettings.BeforePath = $null;
	}
	if ($global:GitPromptSettings.PSObject.Properties.Name -contains 'DefaultBeforeSuffix') {
		$global:GitPromptSettings.DefaultPromptBeforeSuffix = $null;
	}
	if ($global:GitPromptSettings.PSObject.Properties.Name -contains 'DefaultPromptSuffix') {
		$global:GitPromptSettings.DefaultPromptSuffix = $null;
	}
	if ($global:GitPromptSettings.PSObject.Properties.Name -contains 'DefaultPromptAbbreviateHomeDirectory') {
		$global:GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true;
	}
	if ($global:GitPromptSettings.PSObject.Properties.Name -contains 'DefaultPromptAbbreviateGitDirectory') {
		$global:GitPromptSettings.DefaultPromptAbbreviateGitDirectory = $false;
	}
}

$DotSourceNames = @('machine.ps1', 'os.ps1');
foreach ($DotSourceName in $DotSourceNames) {
	$DotSourcePath = Join-Path -Path $ProfileDirectory -ChildPath $DotSourceName;
	if (Test-Path -Path $DotSourcePath) {
		. $DotSourcePath;
	}
}
