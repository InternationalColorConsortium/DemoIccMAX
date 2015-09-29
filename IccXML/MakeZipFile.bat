REM @echo off
cd IccLibXML
doxygen Doxygen_Config
doxygen Doxygen_Config_Web
cd ..

REM dateyymmdd "SET MYPATH=dist\SampleICC" >mypath.bat
REM call mypath.bat
REM del mypath.bat
call SetVersion "dist\IccXML"

mkdir %mypath%
copy *.html %mypath%

copy .* %mypath%
copy *. %mypath%
copy *.ac %mypath%
copy *.sub %mypath%
copy *.guess %mypath%
del %mypath%\configureProto.ac
copy Makefile.am %mypath%
copy Makefile.in %mypath%
copy *.m4 %mypath%
copy *.OSX %mypath%
copy *.win %mypath%
copy README.* %mypath%

mkdir %mypath%\Build
mkdir %mypath%\Build\MSVC8
copy Build\MSVC8\*.sln %mypath%\Build\MSVC8
copy Build\MSVC8\*.vcproj %mypath%\Build\MSVC8

copy Build %mypath%\Docs

mkdir %mypath%\Docs
copy Docs %mypath%\Docs

mkdir %mypath%\Examples
copy Examples %mypath%\Examples

mkdir %mypath%\XMLSchema
copy XMLSchema\*.rnc %mypath%\XmlSchema
copy XMLSchema\*.rng %mypath%\XmlSchema

mkdir %mypath%\IccLibXML
copy IccLibXML\*.cpp %mypath%\IccLibXML
copy IccLibXML\*.h %mypath%\IccLibXML
copy IccLibXML\*.dsp %mypath%\IccLibXML
copy IccLibXML\*.vcproj %mypath%\IccLibXML
copy IccLibXML\Makefile %mypath%\IccLibXML
copy IccLibXML\*.am %mypath%\IccLibXML
copy IccLibXML\*.in %mypath%\IccLibXML
del %mypath%\IccLibXML\Onx*

mkdir %mypath%\IccLibXML\Docs
mkdir %mypath%\IccLibXML\Docs\html
copy IccLibXML\Docs\html %mypath%\IccLibXML\Docs\html

mkdir %mypath%\IccLibXML\Release
copy IccLibXML\Release\*.exe %mypath%\IccLibXML\Release

mkdir %mypath%\CmdLine
copy CmdLine\.* %mypath%\CmdLine
copy CmdLine\*.am %mypath%\CmdLine
copy CmdLine\*.in %mypath%\CmdLine

mkdir %mypath%\CmdLine\IccFromXml
copy CmdLine\IccFromXml\*.cpp %mypath%\CmdLine\IccFromXml
copy CmdLine\IccFromXml\*.h %mypath%\CmdLine\IccFromXml
copy CmdLine\IccFromXml\*.dsp %mypath%\CmdLine\IccFromXml
copy CmdLine\IccFromXml\*.vcproj %mypath%\CmdLine\IccFromXml
copy CmdLine\IccFromXml\*.pdf %mypath%\CmdLine\IccFromXml
copy CmdLine\IccFromXml\*.am %mypath%\CmdLine\IccFromXml
copy CmdLine\IccFromXml\*.in %mypath%\CmdLine\IccFromXml

mkdir %mypath%\CmdLine\IccFromXml\Release
copy CmdLine\IccFromXml\Release\*.exe %mypath%\CmdLine\IccFromXml\Release

mkdir %mypath%\CmdLine\IccToXml
copy CmdLine\IccToXml\*.cpp %mypath%\CmdLine\IccToXml
copy CmdLine\IccToXml\*.h %mypath%\CmdLine\IccToXml
copy CmdLine\IccToXml\*.dsp %mypath%\CmdLine\IccToXml
copy CmdLine\IccToXml\*.vcproj %mypath%\CmdLine\IccToXml
copy CmdLine\IccToXml\*.am %mypath%\CmdLine\IccToXml
copy CmdLine\IccToXml\*.in %mypath%\CmdLine\IccToXml

mkdir %mypath%\CmdLine\IccToXml\Release
copy CmdLine\IccToXml\Release\*.exe %mypath%\CmdLine\IccToXml\Release

cd dist
REM dateyymmdd "SET MYPATH=IccXML" >mypath.bat
REM call mypath.bat
REM del mypath.bat
call ..\..\SetVersion "IccXML"

"d:\program files\winzip\wzzip" -rp -P %mypath%.zip %mypath%
cd ..

