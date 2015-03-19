#a powershell script for sorting the files on the root of drive.

$tg='f:\'  #modify this value to set the drive

$files=[System.IO.Directory]::GetFiles($tg)
$files | ForEach-Object {
    $ext=[System.IO.Path]::GetExtension($_)
    if($ext.Length -ge 2)
    {
        $ext=$ext.Substring(1)
    }
    else 
    {
        $ext='misc'
    }
    $tp=[System.IO.Path]::Combine($tg,$ext)
    if( -Not [System.IO.Directory]::Exists($tp))
    {
        [System.IO.Directory]::CreateDirectory($tp)
    }
    $src_file=$_
    $t_file=$tp+'\' +[System.IO.Path]::GetFileName($_)
    [System.IO.File]::Move($src_file ,$t_file)
}