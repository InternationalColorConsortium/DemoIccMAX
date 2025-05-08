/*
## 
## Copyright (c) 2024-2025. David H Hoyt LLC. All rights reserved.
#
# Source: IccServiceEndpoint for iccToXml
# Target Platform: Windows (MSVC or clang-cl)
# Toolchain: nmake + C++17
#
## Written by David Hoyt 
## Date: 17-APRIL-2025 0900 EDT
#
# Branch: PR125
# Intent: Build iis endpoint services for iccToXml
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

#include "EmbeddedUI_icctoxml.h"

using namespace web;
using namespace web::http;
using namespace web::http::experimental::listener;

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
  request.extract_vector().then([=](std::vector<uint8_t> body) {
    std::wcout << L"[+] [icctoxml] Received POST request\n";
    std::wcout << L"[+] ICC payload size: " << body.size() << std::endl;

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
    std::filesystem::create_directory("failed_icc");

    std::string iccInputFile = "temp_input.icc";
    std::string xmlOutputFile = "temp_output.xml";
    std::string stderrFile = "temp_stderr.log";
    std::string logFile = "logs/log_req_icctoxml_" + tag + ".log";
    std::string failIccFile = "failed_icc/fail_input_" + tag + ".icc";

    std::ofstream iccOut(iccInputFile, std::ios::binary);
    iccOut.write(reinterpret_cast<const char*>(body.data()), body.size());
    iccOut.close();

    std::string command = ".\\iccToXml.exe " + iccInputFile + " " + xmlOutputFile + " 2> " + stderrFile;
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
      std::ofstream failOut(failIccFile, std::ios::binary);
      failOut.write(reinterpret_cast<const char*>(body.data()), body.size());
      failOut.close();
      std::remove(iccInputFile.c_str());
      http_response response(status_codes::InternalError);
      response.set_body("iccToXml.exe failed. See logs/ and failed_icc/.");
      response.headers().add(U("Access-Control-Allow-Origin"), U("*"));
      request.reply(response);
      return;
    }

    std::ifstream file(xmlOutputFile, std::ios::binary | std::ios::ate);
    if (!file) {
      std::remove(iccInputFile.c_str());
      http_response response(status_codes::InternalError);
      response.set_body("Failed to open XML output.");
      response.headers().add(U("Access-Control-Allow-Origin"), U("*"));
      request.reply(response);
      return;
    }

    std::streamsize size = file.tellg();
    file.seekg(0, std::ios::beg);
    std::string xmlContents(size, '\0');
    file.read(&xmlContents[0], size);
    file.close();

    std::remove(iccInputFile.c_str());
    std::remove(xmlOutputFile.c_str());

    http_response response(status_codes::OK);
    response.set_body(xmlContents, "application/xml; charset=utf-8");
    response.headers().add(U("Access-Control-Allow-Origin"), U("*"));
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
  banner << L"[+] ICC-to-XML Service Starting\n";
  banner << L"    Timestamp   : " << timestampStream.str() << L"\n";
  banner << L"    Endpoint    : http://localhost:8183/icctoxml\n";
  banner << L"    Thread ID   : " << std::this_thread::get_id() << L"\n";
  banner << L"=============================================\n";
  std::wcout << banner.str();

  std::filesystem::create_directory("logs");
  std::wofstream startupLog(L"logs/service_startup_icctoxml.log", std::ios::app);
  if (startupLog) {
    startupLog << banner.str();
    startupLog.close();
  }

  uri_builder uri(U("http://localhost:8183"));
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
