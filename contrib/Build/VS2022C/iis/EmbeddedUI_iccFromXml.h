/* 
#################################################################################
# EmbeddedUI_iccFromXml.h | IIS STUB
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

// EmbeddedUI_iccfromxml.h
#pragma once

const char* embedded_ui_html = R"rawliteral(
<!DOCTYPE html>
<html lang="en">
<head>
    <title>ICC XML Submission</title>
    <meta name="description" content="Submit ICC XML and get ICC file">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta charset="UTF-8">
</head>
<body>
    <h1>Submit ICC XML</h1>
    <textarea id="xmlInput" rows="20" cols="80" placeholder="Paste ICC XML here"></textarea><br><br>
    <button onclick="submitXml()">Submit</button>
    <script>
    async function submitXml() {
      const xml = document.getElementById("xmlInput").value;
      const res = await fetch("/iccfromxml", {
        method: "POST",
        headers: { "Content-Type": "text/plain; charset=utf-8" },
        body: xml
      });

      if (!res.ok) {
        alert("Error: " + await res.text());
        return;
      }

      const blob = await res.blob();
      const a = document.createElement("a");
      a.href = URL.createObjectURL(blob);
      a.download = "output.icc";
      a.style.display = "none";
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
    }
    </script>
</body>
</html>
)rawliteral";
