# WASM iccTiffDump Reproduction

**How-To**

1. Clone the Repo
2. cd `iccDEV\contrib\Build\cmake\cov\wasm\Tools\IccTiffDump`
3. run `python3 -m http.server`
4. Open URL http://localhost:8000/iccTiffDump.html

**HTTP Log Output**
```
python3 -m http.server
Serving HTTP on :: port 8000 (http://[::]:8000/) ...
::1 - - [27/Jul/2025 20:23:18] "GET / HTTP/1.1" 200 -
::1 - - [27/Jul/2025 20:23:18] code 404, message File not found
::1 - - [27/Jul/2025 20:23:18] "GET /favicon.ico HTTP/1.1" 404 -
::1 - - [27/Jul/2025 20:23:20] "GET /iccTiffDump.html HTTP/1.1" 200 -
::1 - - [27/Jul/2025 20:23:20] "GET /iccTiffDump.js HTTP/1.1" 200 -
::1 - - [27/Jul/2025 20:23:20] "GET /iccTiffDump.wasm HTTP/1.1" 200 -
```
## Expected Output

3. iccTiffDump
[![TiffDump Pic](https://github.com/InternationalColorConsortium/iccDEV/blob/research/contrib/Build/cmake/cov/wasm/Tools/IccTiffDump/iccdev-wasm-icctiffdump-web-spa-example-001.png?raw=true "color.org")](https://color.org)


