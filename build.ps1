$uma_output_dir=$args[0];
$current_dir=$PSScriptRoot;

for ( $i = 0; $i -lt 5; $i++ )
{
    if((git pull -f) -and (git submodule update --init --recursive))
    {
        break;
    }
    Start-Sleep -Seconds 60;
}

$list=Get-ChildItem -Path "${current_dir}" -Directory;
foreach($dir in $list)
{
    $full_dir=${dir}.FullName;
    cd "${full_dir}";
    rm .\dist  -r -Force;
    pyinstaller umatracker-win.spec;
    mv .\dist\* "${uma_output_dir}";
}

cd "${current_dir}";
