rem ---------------------------------------------------------
rem SAFIR - Structural_2D gestartet von GiD
rem ----------------------------------------------------------
rem
rem OutputFile: %1.txt
rem ErrorFile: %1.err
Rem if NOT %SAFIR_DIR%=="" goto L1
set SAFIR_DIR = C:\SAFIR2011
:L1 echo SAFIR_DIR = %SAFIR_DIR%
rem
set GiD_DIR = %3
rem
set FixPath = %GiD_DIR%
set ResPath = %GiD_DIR%
rem
del %1.in
del %1.in0
del %1.out
del %1.flavia.mesh
del %1.flavia.res
rem 
%FixPath%\Structural2dfix.exe %1 >> %1.txt
rem 
echo %1 > infile
%SAFIR_DIR%\safir2011.exe < infile >> %1.txt
rem
del %1.flavia.res
%ResPath%\Structural2dres.exe %1 >> %1.txt
if not exist %2\%1.flavia.res echo "No .out-file or results in .out-file found"  >> %2\%1.err
rem
rem SAFIR Ende ------------------------------------------------
