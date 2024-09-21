@rem Copyright 2024 Elloramir.
@rem All rights over the code are reserved.
@echo off

if exist dist rmdir /s /q dist
mkdir dist

@rem create game.love
7z a -tzip dist/game.love ./

@rem download love2d binaries
curl -L https://github.com/love2d/love/releases/download/11.5/love-11.5-win64.zip -o dist/love-11.5-win64.zip

@rem unzip love2d binaries
7z x -odist dist/love-11.5-win64.zip

@rem copy game.love to love2d binaries
copy /b dist\love-11.5-win64\love.exe+dist\game.love dist\love-11.5-win64\game.exe

@rem cleanup
del dist\love-11.5-win64.zip
del dist\game.love
del dist\love-11.5-win64\love.exe
del dist\love-11.5-win64\lovec.exe
del dist\love-11.5-win64\readme.txt
del dist\love-11.5-win64\changes.txt
del dist\love-11.5-win64\license.txt
del dist\love-11.5-win64\love.ico
del dist\love-11.5-win64\game.ico

@rem transform love-11.5-win64 to a game.zip file
@rem it is important to create a zip on relative path
pushd dist\love-11.5-win64
set timedate=%date:~0,2%.%date:~3,2%.%date:~6,4%
7z a -tzip ..\game.win64.%timedate%.zip ./*
popd

@rem cleanup
rmdir /s /q dist\love-11.5-win64