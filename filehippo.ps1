$AllProtocols = [System.Net.SecurityProtocolType]'Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols



$textfile = "$PSScriptRoot\textfile.txt"

Clear-Variable text -ErrorAction SilentlyContinue

for ($i = 1; $i -le 10; $i++)
{ 
    $request = Invoke-Webrequest -URI https://filehippo.com/en/latest/$i/
    $text += @(($request.Links | Where {$_.OuterHTML -match "<SPAN class=program-title-text>"}).OuterText)
    
}

$text | Out-File $textfile

$packagelist = Get-Content "$PSScriptRoot\packagelist.txt"

Foreach($line in $packagelist){

    $text | % { if(($_ -match $line) -and ($_ -notmatch 'Beta')) {write-host $_}}

}

pause