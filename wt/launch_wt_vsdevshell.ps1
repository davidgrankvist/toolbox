# Open a terminal with two VS dev shell tabs.

$vsdevshell="C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1"

wt `
    new-tab `
        --profile "Windows Powershell" `
        powershell -NoExit -Command "& '$vsdevshell'" `
        `; `
    new-tab `
        --profile "Windows Powershell" `
        powershell -NoExit -Command "& '$vsdevshell'"

