rem ----------------------------------------------------------
rem SAFIR - Thermal-3D gestartet von GID
rem ----------------------------------------------------------
rem if NOT %SAFIR_DIR%=="" goto L1
set SAFIR_DIR = C:\SAFIR2011
:L1 echo SAFIR_DIR = %SAFIR_DIR%
set GID_DIR = %3
rem
rem ----------------------------------------------------------
rem OutputFile: %1.txt
rem ErrorFile: %1.err
rem
del %1.in
del %1.out
del %1.flavia.msh
del %1.flavia.res
rem
set ResPath = %GiD_DIR%
rem
rem set ResPath = %GiD_DIR%\resdat\Debug
rem
echo ResPath = %ResPath%
rem
copy %1.dat %1.in
echo %1 > infile
%SAFIR_DIR%\safir2011.exe < infile >> %1.txt
rem
%ResPath%\resdat.exe %1 >> %1.txt
if not exist %2\%1.flavia.res echo "Program failed" >> %2\%1.err
echo Postprocessor Data generated >> %1.txt
rem
rem SAFIR Ende ----------------------------------------------
