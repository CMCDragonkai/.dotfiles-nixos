# This is for the current user only and only for Microsoft.Powershell console host

$host.ui.rawui.foregroundcolor = "white"

Import-Module PSReadLine

Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
Set-PSReadLineOption -MaximumHistoryCount 4096
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

function prompt {

    $flag = $?
    $realLASTEXITCODE = $LASTEXITCODE

    # prepend a newline if the prior command did not terminate with a newline
    if ($host.ui.rawui.cursorposition.x -eq 0) {
        $prompt_prefix = ""
    } else {
        $prompt_prefix = "`n"
    }

    $status_prompt = if ($flag) {
        @{ prompt =" >"; color = "darkgreen" }
    } else {
        @{ prompt = " >" ; color = "red" }
    }

    Write-Host -nonewline ($prompt_prefix + $env:username + " | " + $env:computername + " | " + (get-location) + "`n") -foregroundColor "cyan"
    Write-Host -nonewline $status_prompt.prompt -foregroundColor $status_prompt.color

    $global:LASTEXITCODE = $realLASTEXITCODE
    return " "

}
