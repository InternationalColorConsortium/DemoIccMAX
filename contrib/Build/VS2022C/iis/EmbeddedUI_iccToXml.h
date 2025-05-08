/* 
#################################################################################
# EmbeddedUI_iccToXml.h | IIS STUB
# Copyright (C) 2020-2025 David H Hoyt LLC.
#                                          All rights reserved.
#                   https://srd.cx
#
# Last Updated: 17-APRIL-2025 0800 EDT by David Hoyt
#
# Intent:  NOT FOR COMMERCIAL USE (OR INTERNET FACING USE) 
#          IIS Listener on Locahost:Port
#          This Tooling is part of the iccMAX CICD Pipeline
#
# Use Cases: Convert XML<->ICC, BurpSuite Pro, AFL, Fuzzing
#
#
# RUN from Source Build Location cov/Build/VS2022C/iis
# STUB IIS Listener on Locahost:Port for Fuzzing via Burp Suite Pro, CLI Tooling
##################################################################################
*/ 

#pragma once

const char* embedded_ui_html = R"rawliteral(
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Hoyt's ICC Profile Converter</title>
    <meta name="description" content="Hoyt's ICC Profile Converter">
    <meta name="keywords" content="Hoyt's ICC Profile Converter">
    <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta charset="UTF-8">
  <title>Hoyt's ICC Profile Converter</title>
</head>
<body>
  <h1>Upload ICC Profile File</h1>
  <input type="file" id="iccFile" accept=".icc"/><br><br>
  <button onclick="submitIcc()">Submit</button>
  <script>
    async function submitIcc() {
      const fileInput = document.getElementById("iccFile");
      if (!fileInput.files.length) {
        alert("Please select an ICC file.");
        return;
      }

      const file = fileInput.files[0];
      const blob = file;

      const res = await fetch("/icctoxml", {
        method: "POST",
        headers: { "Content-Type": "application/octet-stream" },
        body: blob
      });

      if (!res.ok) {
        alert("Error: " + await res.text());
        return;
      }

      const xml = await res.text();
      const blobOut = new Blob([xml], { type: "application/xml" });
      const a = document.createElement("a");
      a.href = URL.createObjectURL(blobOut);
      a.download = file.name.replace(/\.icc$/, ".xml");
      a.style.display = "none";
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
    }
  </script>
</body>
</html>
)rawliteral";
