$uma_output_dir=$args[0];
$current_dir=$PSScriptRoot;

$success = $false;
do {
    try
    {
        git pull -f;
        git submodule update --init --recursive;
        $success = $true;
    }
    catch [System.Exception]
    {
        Start-Sleep -Seconds 60;
    }
} while (!$success);

cp .\LICENSE.txt "${uma_output_dir}";

$list=Get-ChildItem -Path "${current_dir}" -Directory;
foreach($dir in $list)
{
    $full_dir=${dir}.FullName;
    cd "${full_dir}";
    if (Test-Path "umatracker-win.spec") {
        rm .\dist  -r -Force;
        pyinstaller umatracker-win.spec;
        mv .\dist\* "${uma_output_dir}";
    }
}

cd "${current_dir}";
