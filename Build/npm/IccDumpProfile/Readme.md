# WASM iccDumpProfile Reproduction

**How-To**

1. Clone the Repo
2. cd `iccDEV\contrib\Build\cmake\cov\wasm\Tools\IccDumpProfile`
3. run `python3 -m http.server`
4. Open URL http://localhost:8000/iccDumpProfile.html

**HTTP Log Output**
```
python3 -m http.server
Serving HTTP on :: port 8000 (http://[::]:8000/) ...
::1 - - [27/Jul/2025 20:23:08] "GET / HTTP/1.1" 200 -
::1 - - [27/Jul/2025 20:23:08] code 404, message File not found
::1 - - [27/Jul/2025 20:23:08] "GET /favicon.ico HTTP/1.1" 404 -
::1 - - [27/Jul/2025 20:23:10] "GET /iccDumpProfile.html HTTP/1.1" 200 -
::1 - - [27/Jul/2025 20:23:10] "GET /iccDumpProfile.js HTTP/1.1" 200 -
::1 - - [27/Jul/2025 20:23:10] "GET /iccDumpProfile.wasm HTTP/1.1" 200 -
```
## Expected Output

3. iccDumpProfile
[![DumpProfile Pic](https://github.com/InternationalColorConsortium/iccDEV/blob/research/contrib/Build/cmake/cov/wasm/Tools/IccDumpProfile/iccdev-wasm-iccdumpprofile-web-spa-example-001.png?raw=true "color.org")](https://color.org)


