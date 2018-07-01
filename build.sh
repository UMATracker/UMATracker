current_dir=$(pwd)

n=0
until [ $n -ge 5 ]
do
    git pull -f && git submodule update --init --recursive && break
    n=$[$n+1]
    sleep 60
done

cp ./LICENSE.txt "${UMA_OUTPUT_PATH}"

for entry in "${current_dir}"/*/
do
    cd ${entry}

    if [ -f "umatracker-mac.spec" ]
    then
        rm -rf ./dist
        pyinstaller umatracker-mac.spec
        mv "${entry}/dist"/*.app "${UMA_OUTPUT_PATH}"
    fi
done

