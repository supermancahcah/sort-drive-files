#a powershell script for sorting the files on the root of drive.

$tg='f:\'  #modify this value to set the drive

$files=[System.IO.Directory]::GetFiles($tg)
$files | ForEach-Object {
    $ext=[System.IO.Path]::GetExtension($_)

    if($ext.Length -ge 2)
    {
        $ext=$ext.Substring(1).ToLower()
        if($ext -eq 'htm') {$ext='html'}
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

#specially try to process html and htm files.
$tp2=$tg+'htm'
$tp3=$tg+'html'
$htmlDirExist=[System.IO.Directory]::Exists($tp3)

if([System.IO.Directory]::Exists($tp2))
{
    #insure the html dir exist
    if(-Not $htmlDirExist)
    {
        [System.IO.Directory]::CreateDirectory($tp3)
    }

    #move the html files to html dir
    [String[]]$htms=[System.IO.Directory]::GetFiles($tp2,'*.htm')
    Foreach ($htm in $htms)
    {
        $htm_file_name=[System.IO.Path]::GetFileName($htm)
        [System.IO.File]::Move($htm,$tp3+'\'+$htm_file_name)
    }

    Foreach ($htm in $htms)
    {
        $htm_file_name_we=[System.IO.Path]::GetFileNameWithoutExtension($htm)
        $htm_dir=$tp2+'\'+$htm_file_name_we+'_files'
        if([System.IO.Directory]::Exists($htm_dir))
        {
            [System.IO.Directory]::Move($htm_dir,$tp3+'\'+$htm_file_name_we+'_files')
        }
    }

    $htms=[System.IO.Directory]::GetFiles($tp2,'*.html')
    Foreach ($htm in $htms)
    {
        $htm_file_name=[System.IO.Path]::GetFileName($htm)
        [System.IO.File]::Move($htm,$tp3+'\'+$htm_file_name)
    }

    Foreach ($htm in $htms)
    {
        $htm_file_name_we=[System.IO.Path]::GetFileNameWithoutExtension($htm)
        $htm_dir=$tp2+'\'+$htm_file_name_we+'_files'
        if([System.IO.Directory]::Exists($htm_dir))
        {
            [System.IO.Directory]::Move($htm_dir,$tp3+'\'+$htm_file_name_we+'_files')
        }
    }

    [String[]]$htm_dirs=[System.IO.Directory]::GetDirectories($tp2)

    Foreach ($htm_dir in $htm_dirs)
    {
        if($htm_dir.EndsWith('_files'))
        {
            [System.IO.Directory]::Move($htm_dir,$tp3+'\'+[System.IO.Path]::GetFileName($htm_dir))
        }
    }

    #delete the htm folder if the folder is empty.
    [String[]]$any_files=[System.IO.Directory]::GetFiles($tp2)
    [String[]]$any_dirs=[System.IO.Directory]::GetDirectories($tp2)
    if((-Not $any_files) -and (-Not $any_dirs)) {[System.IO.Directory]::Delete($tp2)}
}

if([System.IO.Directory]::Exists($tp3))
{
    [String[]]$htmls=[System.IO.Directory]::GetFiles($tp3)
    $htmlsWithtouExt= New-Object -TypeName System.Collections.ArrayList
    For($i = 0 ; $i -lt $htmls.length; $i ++) 
    {
        [String]$html=$htmls[$i]
        $htmlWithoutExt=[System.IO.Path]::GetFileNameWithoutExtension($html)
        $htmlsWithtouExt.Add($htmlWithoutExt)
    }

     Foreach ($htmlWE in $htmlsWithtouExt)
    {
        $dir_name=$htmlWE+'_files'
        if([System.IO.Directory]::Exists($tg+$dir_name))
        {
            [System.IO.Directory]::Move($tg+$dir_name,$tp3+'\'+$dir_name)
        }
    }
}