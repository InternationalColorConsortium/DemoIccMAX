
# Latest Release of iccMAX

- macOS
- Ubuntu
- Windows
- WASM
- Node

Download your binary package and unzip to run the tools on the command line. The WebAssembly build (iccWASM) wraps the iccDEV Command Line Tools in JavaScript enabling color profile development using modern web browsers. 

### Manual Unzip

How-to get iccDEV running in a web browser:

1. Download iccwasm-preview-v2.2.61.zip
2. Unzip iccWASM Zip file
3. Open a pwsh terminal to Tools\IccDumpProfile directory
4. Run the command `python3 -m http.server`
5. Browse the URL `http://localhost:8000/iccDumpProfile.html`
6. Select an ICC Color Profile to be dumped
7. Click on Run Dump
8. View the output