Import-Module $PSScriptRoot\DownloadAndUnpack-Dynamics365Resource.psm1 -DisableNameChecking
function Save-Dynamics365Resource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0)]
        [ArgumentCompleter(
            {
                $Dynamics365Resources | Get-Member -MemberType NoteProperty | ForEach-Object { $_.Name }
            }
        )]
        [ValidateScript(
            {
                $Dynamics365Resources.$_
            }
        )]
        [string]
        $Resource,
        [Parameter(Position=1)]
        [string]
        $TargetDirectory
    )
    if ( $resource )
    {
        $resourceUrl = $Dynamics365Resources.$resource.URL;
        if ( $TargetDirectory )
        {
            $directoryPath = $TargetDirectory;
        } else {
            $directoryName = $resource;
            $directoryPath = ".\$directoryName";
            Write-Debug "Directory Path: $directoryPath";
        }
        DownloadAndUnpack-Dynamics365Resource -ResourceUrl $resourceUrl -DirectoryPath $directoryPath -ExpectedFileChecksum $Dynamics365Resources.$resource.checksum;
    } else {
        Write-Debug "Downloading all URLs"
        if ( $TargetDirectory )
        {
            $Dynamics365Resources | Get-Member -MemberType NoteProperty | ForEach-Object {
                $resourceUrl = $Dynamics365Resources.( $_.Name ).URL;
                $directoryName = $_.Name;
                $directoryPath = "$TargetDirectory\$directoryName";
                DownloadAndUnpack-Dynamics365Resource -ResourceUrl $resourceUrl -DirectoryPath $directoryPath;
            }
        } else {
            $Dynamics365Resources | Get-Member -MemberType NoteProperty | ForEach-Object {
                $resourceUrl = $Dynamics365Resources.( $_.Name ).URL;
                $directoryName = $_.Name;
                $directoryPath = ".\$directoryName";
                Write-Output "directoryPath: $directoryPath"
                DownloadAndUnpack-Dynamics365Resource -ResourceUrl $resourceUrl -DirectoryPath $directoryPath;
            }
        }
    }
}
