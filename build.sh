current_dir=$(pwd)

for entry in "${current_dir}"/*/
do
    cd ${entry}

    n=0
    until [ $n -ge 5 ]
    do
        git pull -f && git submodule update --init --recursive && break
        n=$[$n+1]
        sleep 60
    done

    rm -rf ./dist
    pyinstaller umatracker-mac.spec
    mv dist/*.app "${output_loc}"
done
