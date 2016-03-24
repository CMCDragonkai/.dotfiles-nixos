$host.ui.rawui.foregroundcolor = "white"
$host.ui.rawui.backgroundcolor = "black"

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
        @{ prompt = " >" ; color = "darkred" } 
    }

    Write-Host -nonewline ($prompt_prefix + $env:user + " | " + $env:computername + " | " + (get-location) + "`n") -foregroundColor "cyan"
    Write-Host -nonewline $status_prompt.prompt -foregroundColor $status_prompt.color

    $global:LASTEXITCODE = $realLASTEXITCODE
    return " "
    
}