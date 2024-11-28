@echo off
setlocal

set /p repo=Repo: 
set /p ns=Namespace: 
set /p desc=Description: 

set appNs=%ns%.App
set libNs=%ns%.Lib
set testNs=%ns%.Test

echo Setting up project in %repo%

echo Creating directories

mkdir %repo%
pushd %repo%

mkdir %appNs%
mkdir %libNs%
mkdir %testNs%

echo Creating README

echo # %ns% > README.md
echo %desc% >> README.md

echo Setting up solution and projects

dotnet new sln

echo Creating lib
pushd %libNs%
dotnet new classlib
popd

echo Creating app
pushd %appNs%
dotnet new console
dotnet add reference ..\%libNs%
popd

echo Creating test
pushd %testNs%
dotnet new mstest
dotnet add reference ..\%libNs%
popd

dotnet sln add %appNs%
dotnet sln add %libNs%
dotnet sln add %testNs%

echo Initializing git repo

git init
dotnet new gitignore
REM prevent the console project from being ignored by removing the "*.app" pattern
type .gitignore | findstr /V "^\*\.app$" > .gitignore_temp
del .gitignore
ren .gitignore_temp .gitignore

git add .
git commit -m "init"

echo Done!

popd
endlocal
