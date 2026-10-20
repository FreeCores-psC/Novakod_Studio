k# Changelog
This change log describes the chages to the installed **C:\\Novakod_Studio** directory . Some changes may affect backend and frontend.

## [V6.1]

#### Added
- Bsp DE1SoC: CopyFiles added to make vhdl directory complete for download and synthesis. 
#### Fixed
- Compiler bug: setup() with local variables.
- Compiler: return; not required at the end of a function.
#### Changed
- Rename C:\N_S\WebBsp\ to C:\N_S\WebViewer\.
- Console: index.html move to C:\N_S\WebViewer\Console and removed from WebTemplates Console projects.
- Modifications in WebExamples to prepare for library management.
#### Removed
C:\N_S\WebViewer\Consolek
## [V6]  < 2-22-2026 >

#### Added
- Directory WebBsp\DE1SoC\ with:
    - BoardPicture.jpg
    - index.html
    - layout.json
    - StartClient.bat
    - StartServer.bat
- These files were previously in the template[k](ChangeLog.md)
- Added template GenVhdlDE1SoC, to be used for VHDL code generation.
#### Fixed
-
#### Changed
- New GenVcdFile.exe, pscc.exe, VhdlMapper.exe,WebGenEnvFile.exe 
- DE1SoC modified: C:\Novakod_Studio\bsp\TerasicDE1SoC
#### Removed
- Directory WebVcdFiles

