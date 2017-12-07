rem --------------------------------------------------------
rem SAFIR - Static 3D gestartet von GID
rem -----------------------------------------------------------
rem
rem OutputFile: %1.txt
rem ErrorFile: %1.err
rem if NOT %SAFIR_DIR%=="" goto L1
set SAFIR_DIR = C:\SAFIR2011
:L1 echo SAFIR_DIR = %SAFIR_DIR%
rem
set GID_DIR = %3
rem
del %1.in
del %1.in0
del %1.out
del %1.flavia.mesh
del %1.flavia.res
rem
set FixPath = %GiD_DIR%
set ResPath = %GiD_DIR%
rem
%FixPath%\Structural3dfix.exe %1 >> %1.txt
rem
echo %1 > infile
%SAFIR_DIR%\safir2011.exe < infile >> %1.txt
rem
del %1.flavia.res
echo "STRUCTURAL3DRES.exe creates Postprocessor-File for GID" >> %1.txt
%ResPath%\Structural3dres.exe %1 >> %1.txt
if not exist %2\%1.flavia.res echo "No .out-file or results in .out-file found" >> %2\%1.err
rem
rem SAFIR End ---------------------------------------------------------
