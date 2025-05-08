/*
## 
## Copyright (c) 2024-2025. David H Hoyt LLC. All rights reserved.
#
# Source: IccServiceEndpoint for iccFromXml
# Target Platform: Windows (MSVC or clang-cl)
# Toolchain: nmake + C++17
#
## Written by David Hoyt 
## Date: 03-MAR-2025 0900 EDT
#
# Branch: PR121
# Intent: Build iis endpoint services
# Production: TRUE
# Runner: TRUE
#
#
# Use Cases: Convert XML<->ICC, BurpSuite Pro, AFL, Fuzzing
# NOT FOR COMMERCIAL USE (OR INTERNET FACING USE)
*/

#include <cstdlib>
#include <cstdio>
#include <chrono>
#include <ctime>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <filesystem>
#include <thread>

#include "cpprest/http_listener.h"
#include "cpprest/filestream.h"

#include "IccTagXmlFactory.h"
#include "IccMpeXmlFactory.h"
#include "IccProfileXml.h"
#include "IccIO.h"
#include "IccUtil.h"
#include "IccProfLibVer.h"
#include "IccLibXMLVer.h"

using namespace web;
using namespace web::http;
using namespace web::http::experimental::listener;

const std::string embedded_ui_html = R"rawliteral(
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>ICC XML to ICC Converter</title>
</head>
<body>
  <h1>Upload ICC XML</h1>
  <textarea id="xmlInput" rows="10" cols="80"></textarea><br>
  <button onclick="submitXml()">Submit</button>
  <a id="downloadLink" style="display:none;">Download ICC</a>
  <script>
    async function submitXml() {
      const xml = document.getElementById("xmlInput").value;
      const res = await fetch('/iccfromxml', {
        method: 'POST',
        headers: {'Content-Type': 'text/plain'},
        body: xml
      });
      if (!res.ok) {
        alert('Error: ' + await res.text());
        return;
      }
      const blob = await res.blob();
      const url = URL.createObjectURL(blob);
      const a = document.getElementById("downloadLink");
      a.href = url;
      a.download = "result.icc";
      a.style.display = "inline";
      a.textContent = "Download ICC";
    }
  </script>
</body>
</html>
)rawliteral";

void handle_get(http_request request) {
  const auto path = uri::decode(request.relative_uri().path());
  if (path == U("/") || path == U("/ui")) {
    http_response response(status_codes::OK);
    response.set_body(embedded_ui_html, "text/html; charset=utf-8");
    response.headers().add(U("Access-Control-Allow-Origin"), U("*"));
    request.reply(response);
  } else {
    request.reply(status_codes::NotFound, "Not found.");
  }
}

void handle_post(http_request request) {
  request.extract_utf8string().then([=](std::string body) {
    std::wcout << L"[+] [iccfromxml] Received POST request\n";
    std::wcout << L"[+] Extracted UTF-8 body, size: " << body.size() << std::endl;

    auto now = std::chrono::system_clock::now();
    auto time_t_now = std::chrono::system_clock::to_time_t(now);
    std::tm utc_tm;
#ifdef _WIN32
    gmtime_s(&utc_tm, &time_t_now);
#else
    gmtime_r(&time_t_now, &utc_tm);
#endif
    std::ostringstream timestamp;
    timestamp << std::put_time(&utc_tm, "%Y%m%dT%H%M%S");
    std::string tag = timestamp.str();

    std::filesystem::create_directory("logs");
    std::filesystem::create_directory("failed_xml");

    std::string xmlTempFile = "temp_input.xml";
    std::string iccOutputFile = "temp_output.icc";
    std::string stderrFile = "temp_stderr.log";
    std::string logFile = "logs/log_req_" + tag + ".log";
    std::string failInputFile = "failed_xml/fail_input_" + tag + ".xml";

    std::ofstream xmlOut(xmlTempFile, std::ios::binary);
    xmlOut.write(body.c_str(), body.size());
    xmlOut.close();

    std::string command = ".\\iccFromXml.exe " + xmlTempFile + " " + iccOutputFile + " -noid -v= 2> " + stderrFile;
    int result = std::system(command.c_str());

    std::string stderrContents;
    std::ifstream errStream(stderrFile, std::ios::in | std::ios::binary);
    if (errStream) {
      stderrContents.assign((std::istreambuf_iterator<char>(errStream)), std::istreambuf_iterator<char>());
      errStream.close();
      std::remove(stderrFile.c_str());
    } else {
      stderrContents = "[!] Failed to open stderr output file.";
    }

    std::ofstream log(logFile, std::ios::app);
    if (log) {
      log << "TIMESTAMP: " << tag << "Z\n";
      log << "COMMAND: " << command << "\n";
      log << "EXIT CODE: " << result << "\n";
      log << "STDERR:\n" << stderrContents << "\n";
      log << "----------\n";
      log.close();
    }

    if (result != 0) {
      std::ofstream failXml(failInputFile, std::ios::binary);
      if (failXml) {
        failXml.write(body.c_str(), body.size());
        failXml.close();
      }
      std::remove(xmlTempFile.c_str());
      http_response response(status_codes::InternalError);
      response.set_body("iccFromXml.exe failed. See logs/ and failed_xml/.");
      response.headers().add(U("Access-Control-Allow-Origin"), U("*"));
      request.reply(response);
      return;
    }

    std::ifstream file(iccOutputFile, std::ios::binary | std::ios::ate);
    if (!file) {
      std::remove(xmlTempFile.c_str());
      http_response response(status_codes::InternalError);
      response.set_body("Failed to open ICC output.");
      response.headers().add(U("Access-Control-Allow-Origin"), U("*"));
      request.reply(response);
      return;
    }

    std::streamsize size = file.tellg();
    file.seekg(0, std::ios::beg);
    std::vector<uint8_t> buffer(size);
    if (!file.read(reinterpret_cast<char*>(buffer.data()), size)) {
      std::remove(xmlTempFile.c_str());
      std::remove(iccOutputFile.c_str());
      http_response response(status_codes::InternalError);
      response.set_body("Failed to load ICC.");
      response.headers().add(U("Access-Control-Allow-Origin"), U("*"));
      request.reply(response);
      return;
    }

    std::remove(xmlTempFile.c_str());
    std::remove(iccOutputFile.c_str());

    http_response response(status_codes::OK);
    response.set_body(std::move(buffer));
    response.headers().add(U("Access-Control-Allow-Origin"), U("*"));
    response.headers().add(U("Content-Type"), U("application/octet-stream"));
    request.reply(response);
  }).wait();
}

int main() {
  auto now = std::chrono::system_clock::now();
  auto time_t_now = std::chrono::system_clock::to_time_t(now);
  std::tm utc_tm;
#ifdef _WIN32
  gmtime_s(&utc_tm, &time_t_now);
#else
  gmtime_r(&time_t_now, &utc_tm);
#endif
  std::wostringstream timestampStream;
  timestampStream << std::put_time(&utc_tm, L"%Y-%m-%dT%H:%M:%SZ");

  std::wostringstream banner;
  banner << L"\n=============================================\n";
  banner << L"[+] ICC Service Starting\n";
  banner << L"    Timestamp   : " << timestampStream.str() << L"\n";
  banner << L"    Endpoint    : Placeholder\n";
  banner << L"    Thread ID   : " << std::this_thread::get_id() << L"\n";
  banner << L"=============================================\n";
  std::wcout << banner.str();

  std::filesystem::create_directory("logs");
  std::wofstream startupLog(L"logs/service_startup.log", std::ios::app);
  if (startupLog) {
    startupLog << banner.str();
    startupLog.close();
  }

  uri_builder uri(U("http://localhost:8182"));
  http_listener listener(uri.to_uri());
  listener.support(methods::GET, handle_get);
  listener.support(methods::POST, handle_post);

  try {
    listener.open().then([&listener]() {
      std::wcout << L"[+] Service listening at: " << listener.uri().to_string() << std::endl;
    }).wait();
    std::string line;
    std::getline(std::cin, line);
  } catch (const std::exception& e) {
    std::cerr << "[!] Failed to start service: " << e.what() << std::endl;
    std::cerr << "[!] Press Enter to exit..." << std::endl;
    std::cin.get();
  }

  return 0;
}
