
# Signature Verification Overview

This document explains how to verify the authenticity and integrity of Signed Tools, such a the `DemoIccMAXCmm.dll` and other signed files using the Azure Trusted Signing Service and the `signtool` utility.

## Steps for Manual Signature Verification Using `signtool`

### 1. Install `signtool`
The `signtool` utility is part of the Windows SDK. If it is not installed, download it from the [Windows 10 SDK download page](https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk).

### 2. Run `signtool` to Verify the Signature of a File

To verify the signature of any file` file, use the following example:

```powershell
iwr -Uri "https://xss.cx/2024/10/26/signed/DemoIccMAXCmm.dll" -OutFile ".\DemoIccMAXCmm.dll"
& "C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64\signtool.exe" verify /pa /v .\DemoIccMAXCmm.dll
```

### 3. Interpretation of `signtool` Output

#### Primary Signature

- **Signature Index**: This indicates the primary signature (Index: 0).
- **Hash of file (SHA256)**: Ensure that this matches the expected SHA256 hash of the file:
  ```powershell
  Hash of file (sha256): 7E2F11063DAF467FFC5ED1B587B804135CC98F7666A843776EEC3F3B17C7FA2C
  ```

#### Certificate Chain

Verify that the signing certificate is valid and issued by a trusted authority. The signing certificate chain should include:

- **David H Hoyt LLC** (issued by **Microsoft ID Verified CS EOC CA 02**)
- **Microsoft ID Verified Code Signing PCA 2021** (intermediate)
- **Microsoft Identity Verification Root Certificate Authority 2020** (root)

Ensure the issuer, certificate owner, and expiration dates are correct.

#### Timestamp Verification

The signature should be timestamped to ensure it remains valid even after the certificate expires. In the case of `DemoIccMAXCmm.dll`, the timestamp was provided by **DigiCert Trusted G4 RSA4096 SHA256 TimeStamping CA**:

```bash
The signature is timestamped: Tue Oct 29 12:02:20 2024
```

#### Successful Verification

Ensure the result shows **no warnings or errors** and that the signature verification succeeded:
```bash
Successfully verified: .\DemoIccMAXCmm.dll

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0
```

## SHA256 Hashes for Files

Here are the SHA256 hashes for the files you can verify:

- **DemoIccMAXCmm.dll**: `7E2F11063DAF467FFC5ED1B587B804135CC98F7666A843776EEC3F3B17C7FA2C`

## Example Expected Output

```bash
Verifying: .\DemoIccMAXCmm.dll

Signature Index: 0 (Primary Signature)
Hash of file (sha256): 7E2F11063DAF467FFC5ED1B587B804135CC98F7666A843776EEC3F3B17C7FA2C

Signing Certificate Chain:
    Issued to: Microsoft Identity Verification Root Certificate Authority 2020
    Issued by: Microsoft Identity Verification Root Certificate Authority 2020
    Expires:   Sun Apr 16 14:44:40 2045

        Issued to: Microsoft ID Verified Code Signing PCA 2021
        Issued by: Microsoft Identity Verification Root Certificate Authority 2020
        Expires:   Tue Apr 01 16:15:20 2036

            Issued to: Microsoft ID Verified CS EOC CA 02
            Issued by: Microsoft ID Verified Code Signing PCA 2021
            Expires:   Mon Apr 13 13:31:53 2026

                Issued to: David H Hoyt LLC
                Issued by: Microsoft ID Verified CS EOC CA 02
                Expires:   Fri Nov 01 08:51:14 2024

The signature is timestamped: Tue Oct 29 12:02:20 2024
Successfully verified: .\DemoIccMAXCmm.dll

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0
```

## Download Signed Tools

```
iwr -Uri "https://xss.cx/2024/10/26/signed/iccToXml.exe" -OutFile ".\iccToXml.exe"; & ".\iccToXml.exe"
iwr -Uri "https://xss.cx/2024/10/26/signed/iccFromXml.exe" -OutFile ".\iccFromXml.exe"; & ".\iccFromXml.exe"
iwr -Uri "https://xss.cx/2024/10/26/signed/iccDumpProfile.exe" -OutFile ".\iccDumpProfile.exe"; & ".\iccDumpProfile.exe"
iwr -Uri "https://xss.cx/2024/10/26/signed/iccSpecSepToTiff.exe" -OutFile ".\iccSpecSepToTiff.exe"; & ".\iccSpecSepToTiff.exe"
iwr -Uri "https://xss.cx/2024/10/26/signed/iccApplyToLink.exe" -OutFile ".\iccApplyToLink.exe"; & ".\iccApplyToLink.exe"
iwr -Uri "https://xss.cx/2024/10/26/signed/iccApplyProfiles.exe" -OutFile ".\iccApplyProfiles.exe"; & ".\iccApplyProfiles.exe"
iwr -Uri "https://xss.cx/2024/10/26/signed/iccApplyNamedCmm.exe" -OutFile ".\iccApplyNamedCmm.exe"; & ".\iccApplyNamedCmm.exe"
iwr -Uri "https://xss.cx/2024/10/26/signed/iccV5DspObsToV4Dsp.exe" -OutFile ".\iccV5DspObsToV4Dsp.exe"; & ".\iccV5DspObsToV4Dsp.exe"
iwr -Uri "https://xss.cx/2024/10/26/signed/iccRoundTrip.exe" -OutFile ".\iccRoundTrip.exe"; & ".\iccRoundTrip.exe"
iwr -Uri "https://xss.cx/2024/10/26/signed/iccFromCube.exe" -OutFile ".\iccFromCube.exe"; & ".\iccFromCube.exe"
```

## Hashes of Signed Tools

Verify the Signed File Hash

```
Get-ChildItem -Path . -Filter *.exe | ForEach-Object { 
    $exe = $_.Name
    & "C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64\signtool.exe" verify /pa /v $_.FullName | 
    Select-String -Pattern 'Hash of file \(sha256\):' | 
    ForEach-Object { "$($exe): $($_.Line.Split(':')[-1].Trim())" }
}
```

Hashes

```
Issued to: David H Hoyt LLC
Issued by: Microsoft ID Verified CS EOC CA 01
...
iccApplyNamedCmm.exe: 7568D79109620BA32E4092A484C0C476BD559A4DAA4695D6EF039A9541C2EA24
iccApplyProfiles.exe: CF32D7AE44B50480F4407B10BA62631C23B76005AC5FDC6FA3BD56DCAD56980B
iccApplyToLink.exe: FBAEBF2C34349848CDC6FEC60F43D1779CB69FC2FE18180959B816DB7BEAE8D5
iccDumpProfile.exe: 38BEC2AF7473CFF65D01F3CBC6E4F8BADB76C8D5DB25EA1FAF891ED88AF99789
iccFromCube.exe: 50C8E04687288C103024893342526BAE9B2331D7471E90A3A2DC649155499DF0
iccFromXml.exe: 319003C70417CC53EAEF803340265E99F28B05E13366E73E507430878AA00781
iccRoundTrip.exe: 613D46C714B439FEB0B05BE3B86143C56A988310EEF528FAAB5B6FFB610BFFA7
iccSpecSepToTiff.exe: 95A1E60B3F48FEBC12AA0918F9E07391E51596857BA1D1FD0525C00F3BE4BD99
iccToXml.exe: 8528927699BAA8F0D6D8E423A3E5A13D861686FF9922E0D5DFC8C6036BD83122
iccV5DspObsToV4Dsp.exe: FF30D13B36EF783877E50AC6FA810EB54A541D436D0D9E64F861803EE7311963
```

## Troubleshooting

- **Invalid Signature**: Check if the certificate is trusted and ensure the downloaded file's SHA256 hash matches the expected value.
- **Expired Certificate**: Ensure the signature includes a valid timestamp from a trusted authority, such as DigiCert.

