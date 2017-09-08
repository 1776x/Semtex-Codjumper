@echo off
set COMPILEDIR=%CD%
set IWDNAME=codjumper.iwd
set IWDNAME2=codjumper_misc.iwd

color f0
title "MOD COMPILER @ EMZ"
set /p revision=<log\REV.txt

for %%* in (.) do set modname=%%~n*
:MAKEOPTIONS
cls

:MAKEOPTIONS
echo REVISION: %revision%
if not exist log mkdir log
echo ________________________________________________________________________
echo.
echo  Please select an option:
echo    1. Build Fast File
echo    2. Build Fast File Without *.gsc
echo    3. Build IWD File
echo    4. Start Game
echo    5. Dedicated Server
echo    6. Asset Manager
echo    7. RGB Converter
echo    8. Update From SVN (Tortoise SVN)
echo    9. Commit To SVN (Tortoise SVN)
echo.
echo    0. Exit
echo.
echo ________________________________________________________________________
echo.
echo    Mod Name = %modname%
echo.
echo ________________________________________________________________________
echo.
set /p make_option=:
set make_option=%make_option:~0,1%
if "%make_option%"=="1" goto build_ff
if "%make_option%"=="2" goto build_ff_no
if "%make_option%"=="3" goto build_iwd
if "%make_option%"=="4" goto STARTGAME
if "%make_option%"=="5" goto dedicated
if "%make_option%"=="6" goto STARTASSET
if "%make_option%"=="7" goto STARTRGB
if "%make_option%"=="8" goto UPDATE
if "%make_option%"=="9" goto COMMIT

if "%make_option%"=="0" goto FINAL
goto :MAKEOPTIONS

:dedicated
echo %date% - %time% Dedicated Mode >> log\LOG.TXT
cd ..\..\ 
START cod4x17a_dedrun.exe +set dedicated 2 +exec cj.cfg +set fs_game mods/%modname% +map mp_shipment +gametype cj +set net_port 21337
START iw3mp.exe allowdupe +set fs_game mods/%modname% +connect 127.0.0.1:21337
cd %COMPILEDIR%
goto :MAKEOPTIONS

:build_iwd
cls
cd
echo ________________________________________________________________________
echo.
echo  Building %IWDNAME%:
if exist %IWDNAME% del %IWDNAME%

7za a -r -tzip %IWDNAME% images > NUL
7za a -r -tzip %IWDNAME2% weapons > NUL
7za a -r -tzip %IWDNAME2% sun > NUL
7za a -r -tzip %IWDNAME2% sound > NUL

echo.
echo %date% - %time% %IWDNAME% Completed >> log\LOG.TXT
echo.
echo ________________________________________________________________________
echo.
pause
goto :MAKEOPTIONS

:build_ff
cls
cd
echo ________________________________________________________________________
echo.
echo  Building mod.ff:
echo  Deleting old mod.ff file...
if exist mod.ff del mod.ff

if exist preGSC.exe START preGSC.exe -nopause -outfold emz -d

echo  Copying Default Assets
cd ..\..\
if not exist defaultassets mkdir defaultassets
cd defaultassets
xcopy ui ..\raw\ui /SYI > NUL
xcopy ui_mp ..\raw\ui_mp /SYI > NUL
xcopy maps ..\raw\maps /SYI > NUL
xcopy english ..\raw\english /SYI > NUL
xcopy common_scripts ..\raw\common_scripts /SYI > NUL
xcopy codescripts ..\raw\codescripts /SYI > NUL
xcopy character ..\raw\character /SYI > NUL
cd ..\mods\%modname%

echo  Copying rawfiles...
xcopy shock ..\..\raw\shock /SYI > NUL
xcopy images ..\..\raw\images /SYI > NUL
xcopy materials ..\..\raw\materials /SYI > NUL
xcopy sound ..\..\raw\sound /SYI > NUL
xcopy soundaliases ..\..\raw\soundaliases /SYI > NUL
xcopy fx ..\..\raw\fx /SYI > NUL
xcopy mp ..\..\raw\mp /SYI > NUL
xcopy mp ..\..\zone_source\mp /SYI > NUL
xcopy weapons\mp ..\..\raw\weapons\mp /SYI > NUL
xcopy xanim ..\..\raw\xanim /SYI > NUL
xcopy xmodel ..\..\raw\xmodel /SYI > NUL
xcopy xmodelparts ..\..\raw\xmodelparts /SYI > NUL
xcopy xmodelsurfs ..\..\raw\xmodelsurfs /SYI > NUL
xcopy ui ..\..\raw\ui /SYI > NUL
xcopy ui_mp ..\..\raw\ui_mp /SYI > NUL
xcopy english ..\..\raw\english /SYI > NUL
xcopy vision ..\..\raw\vision /SYI > NUL
xcopy rumble ..\..\raw\rumble /SYI > NUL
xcopy animtrees ..\..\raw\animtrees /SYI > NUL
xcopy fonts ..\..\raw\fonts /SYI > NUL
xcopy sun ..\..\raw\sun /SYI > NUL

echo    Copying source code...
xcopy emz ..\..\raw\emz /SYI > NUL
xcopy maps ..\..\raw\maps /SYI > NUL

echo    Copying MOD.CSV...
xcopy mod.csv ..\..\zone_source /SYI > NUL

echo    Compiling mod...

cd ..\..\bin
linker_pc.exe -language english -compress -cleanup mod
cd %COMPILEDIR%
copy ..\..\zone\english\mod.ff


echo  New mod.ff file successfully built!
echo.
echo %date% - %time% MOD.FF Completed >> log\LOG.TXT
echo.
set /a revision=%revision% + 1
echo %revision% > log\REV.TXT
echo ________________________________________________________________________
echo.
pause
goto :MAKEOPTIONS


:build_ff_no
cls
cd
echo ________________________________________________________________________
echo.
echo  Building mod.ff:
echo  Deleting old mod.ff file...
del mod.ff

if exist preGSC.exe START preGSC.exe -nopause -outfold emz -d

echo  Copying Default Assets
cd ..\..\
if not exist defaultassets mkdir defaultassets
cd defaultassets
xcopy ui ..\raw\ui /SYI > NUL
xcopy ui_mp ..\raw\ui_mp /SYI > NUL
xcopy maps ..\raw\maps /SYI > NUL
xcopy english ..\raw\english /SYI > NUL
xcopy common_scripts ..\raw\common_scripts /SYI > NUL
xcopy codescripts ..\raw\codescripts /SYI > NUL
xcopy character ..\raw\character /SYI > NUL
cd ..\mods\%modname%


echo  Copying rawfiles...
xcopy shock ..\..\raw\shock /SYI > NUL
xcopy images ..\..\raw\images /SYI > NUL
xcopy materials ..\..\raw\materials /SYI > NUL
xcopy sound ..\..\raw\sound /SYI > NUL
xcopy soundaliases ..\..\raw\soundaliases /SYI > NUL
xcopy fx ..\..\raw\fx /SYI > NUL
xcopy mp ..\..\raw\mp /SYI > NUL
xcopy weapons\mp ..\..\raw\weapons\mp /SYI > NUL
xcopy xanim ..\..\raw\xanim /SYI > NUL
xcopy xmodel ..\..\raw\xmodel /SYI > NUL
xcopy xmodelparts ..\..\raw\xmodelparts /SYI > NUL
xcopy xmodelsurfs ..\..\raw\xmodelsurfs /SYI > NUL
xcopy ui ..\..\raw\ui /SYI > NUL
xcopy ui_mp ..\..\raw\ui_mp /SYI > NUL
xcopy english ..\..\raw\english /SYI > NUL
xcopy vision ..\..\raw\vision /SYI > NUL
xcopy rumble ..\..\raw\rumble /SYI > NUL
xcopy animtrees ..\..\raw\animtrees /SYI > NUL
xcopy fonts ..\..\raw\fonts /SYI > NUL
xcopy sun ..\..\raw\sun /SYI > NUL

echo    Copying source code...
xcopy maps\createfx ..\..\raw\maps\createfx /SYI > NUL

echo    Copying MODNOGSC.CSV...
xcopy mod_nogsc.csv ..\..\zone_source /SYI > NUL
cd ..\..\zone_source
del mod.csv
ren mod_nogsc.csv mod.csv

cd ..\mods\%modname%

echo    Renaming MOD_NOGSC.CSV to MOD.CSV...
echo    Compiling mod...

cd ..\..\bin
linker_pc.exe -language english -compress -cleanup mod
cd %COMPILEDIR%
copy ..\..\zone\english\mod.ff


echo  New mod.ff file successfully built!
echo.
echo %date% - %time% NOGSC - MOD.FF Completed >> log\LOG.TXT
echo.
set /a revision=%revision% + 1
echo %revision% > log\REV.TXT
echo ________________________________________________________________________
echo.
pause
goto :MAKEOPTIONS

:STARTGAME
cls
echo ________________________________________________________________________
echo.
echo Write Map Name:
echo.
set /p make_opt=:
echo.
echo.
echo Map Name: %make_opt%
echo.
echo ________________________________________________________________________
echo.
echo.
echo Write Game Type:
echo.
set /p make_optgt=:
echo.
echo.
echo Game Type: %make_optgt%
echo.
echo ________________________________________________________________________
echo.
echo %date% - %time% Play Game >> log\LOG.TXT
cd ..\..\
START iw3mp.exe allowdupe +g_gametype %make_optgt% +set fs_game mods/%modname% +developer 2 +devmap %make_opt%
cd %COMPILEDIR%
goto :MAKEOPTIONS

:STARTASSET
cls
echo %date% - %time% Asset Manager >> log\LOG.TXT
cd ..\..\bin
START asset_manager.exe
cd %COMPILEDIR%
goto :MAKEOPTIONS

:STARTRGB
	cls
 	set /p r=Red:
	set /p g=Green:
	set /p b=Blue:

	set /a r=%r%
	set /a g=%g%
	set /a b=%b%
    set /a divider=255
   	set /a floats=3
  
	set /a rd=r/divider
	set /a gd=g/divider
	set /a bd=b/divider

	set ro=%rd%.
	set go=%gd%.
	set bo=%bd%.

:work   
	set /a r=(r-rd*divider)*10
	set /a g=(g-gd*divider)*10
	set /a b=(b-bd*divider)*10

	set /a rd=r/divider
	set /a gd=g/divider
	set /a bd=b/divider
	
	set /a floats=floats-1

	if "%floats%"=="0" goto clean_up

	set ro=%ro%%rd%
	set go=%go%%gd%
	set bo=%bo%%bd%
 	goto work
   
:clean_up
	echo %ro% %go% %bo%
	echo %date% - %time% RGB Converted : %ro% %go% %bo% >> log\LOG.TXT
	echo %ro% %go% %bo%| clip
	echo	Copied to clipboard.
	TIMEOUT /T 2 > NUL
 	goto :MAKEOPTIONS

:UPDATE
	echo UPDATING
	TortoiseProc.exe /command:update /path:"%CD%" /closeonend:0
 	goto :MAKEOPTIONS

:COMMIT
	echo COMMITTING
	TortoiseProc.exe /command:commit /path:"%CD%" /closeonend:0 	
	goto :MAKEOPTIONS

:FINAL
