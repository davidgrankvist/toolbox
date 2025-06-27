#!/usr/bin/sh

helpText="\
INIT C PROJECT

Creates a project with the given name in the target location.
Sets up hello world, scripts, .gitignore, README, etc.

USAGE

To create the project <name> under <target>/<name>, run the following.

./init_c_project_linux.sh <name> <target>

If the project directory already exists, you get a prompt of whether to clear its contents.
To automatically clear without a prompt, set the additional <clean> parameter to "clean".
Other values are interpreted as not cleaning.

./init_c_project_linux.sh <name> <target> <clean>

You can also add a description to put below the title in README.md.

./init_c_project_linux.sh <name> <target> <clean> <desc>

Use the SUMMARY environment variable to output the results.

SUMMARY=brief ./init_c_project_linux.sh <name> <target> <clean>
SUMMARY=verbose ./init_c_project_linux.sh <name> <target> <clean>\
"

set -e

# -- Arguments --

here=$(dirname $0)
name=$1
target=$2
clean=$3
desc=$4
projectDir="$target/$name"

if [ "$DEV_MODE" = "please" ]; then
    echo "Unleashing the secret dev mode. How exciting."
    name="something"
    target="$here/../output"
    clean="clean"
    desc="It's something."
    projectDir="$target/$name"
fi

if [ "$name" = "" ] || [ "$target" = "" ]; then
    echo "$helpText"
    exit 1
fi

# -- Prepare directory --

echo "Setting up project \"$name\" in $projectDir"

if [ -d $projectDir ]; then
    if [ "$clean" = "clean" ]; then
        echo "The project directory already exists. Cleaning."
        input="y"
    else
        read -p "The project directory already exists. Clean it? (y/n) " input
    fi

    if [ "$input" = "y" ]; then
        rm -rf $projectDir/*
    fi
fi

mkdir -p $projectDir

# -- Create files --

# README and LICENSE (MIT)

echo "\
# $name
$desc" > $projectDir/README.md

year=$(date "+%Y")
user=$(git config user.name)
sed -e "s/Copyright.*$/Copyright \(c\) $year $user/" ../LICENSE > $projectDir/LICENSE

# Hello world

mkdir $projectDir/src

printf '#include <stdio.h>

int main() {
    printf("hello\\n");
}
' > $projectDir/src/main.c

# Scripts

mkdir $projectDir/scripts

echo "\
#!/usr/bin/sh

mkdir -p bin

gcc src/*.c -I src/ -g -o bin/$name\
" > $projectDir/scripts/build.sh

echo "\
#!/usr/bin/sh

./bin/$name\
" > $projectDir/scripts/run.sh

echo "\
#!/usr/bin/sh

gdb ./bin/$name\
" > $projectDir/scripts/debug.sh

chmod +x $projectDir/scripts/*.sh

# Configs

echo "\
bin/
" > $projectDir/.gitignore

echo "\
set makeprg=./scripts/build.sh
" > $projectDir/.nvimrc

# -- Output results --

separator="
=============================
"

if [ "$SUMMARY" = "brief" ]; then
    echo "Results:"
    tree -a $projectDir
elif [ "$SUMMARY" = "verbose" ]; then
    echo "\
    $separator
        Results
    $separator
    "

    files=$(find $projectDir -type f | sort)

    for f in $files; do
        echo "File: $f"
        echo ""
        echo "Content:"
        echo ""
        cat $f
        echo "$separator"
    done
fi
