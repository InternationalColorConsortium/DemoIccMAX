## Latest Release: `iccdev-wasm` v2.2.61

Built from [PR152](https://github.com/InternationalColorConsortium/DemoIccdev/pull/152)

### Manual Installation (Local `.tgz` package)

```
# Step 1: Download the .tgz package
wget https://github.com/InternationalColorConsortium/DemoIccMAX/releases/download/v2.2.6/iccmax-npm-2.2.61.tgz

# Step 2: Create a test directory
mkdir test-iccdev
cd test-iccdev

# Step 3: Initialize a new npm project
npm init -y

# Step 4: Install the iccdev-wasm package locally
npm install ../iccdev-npm-2.2.61.tgz

# Step 5: Navigate into the installed module
cd node_modules/iccdev-wasm/

# Step 6: Run tests to verify functionality
node test_iccToXml.js
```

###  pected Output

```text
node test_iccRoundTrip.js
Usage: node iccRoundTrip.js <profile.icc> [rendering_intent=1] [use_mpe=0]

node test_iccFromXml.js
IccFromXml built with IccProfLib Version 2.2.61, IccLibXML Version 2.2.61
Usage: IccFromXml xml_file saved_profile_file {-noid -v{=[relax_ng_schema_file - optional]}}
Profile parsed and saved correctly
Wrote output.icc: 2420 bytes

node test_iccToXml.js
IccToXml built with IccProfLib Version 2.2.61, IccLibXML Version 2.2.61
Usage: IccToXml src_icc_profile dest_xml_file
XML successfully created
```
