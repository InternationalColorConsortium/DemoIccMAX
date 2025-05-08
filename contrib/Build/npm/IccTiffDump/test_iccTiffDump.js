const fs = require("fs");
const createModule = require("./Tools/IccTiffDump/iccTiffDump.js");

const argv = process.argv.slice(2);
if (argv.length < 1) {
  console.error("Usage: node t7.js <input.tiff> [output.icc]");
  process.exit(1);
}

const inputTiff = argv[0];
const outputIcc = argv[1] || "extracted.icc";

createModule({
  print: text => console.log(text),
  printErr: text => console.error("ERR:", text),
}).then((Module) => {
  try {
    const tiffData = fs.readFileSync(inputTiff);
    Module.FS.writeFile("in.tif", tiffData);

    const args = ["in.tif", "out.icc"];
    Module.callMain(args);

    const iccData = Module.FS.readFile("out.icc");
    fs.writeFileSync(outputIcc, iccData);
    console.log(`✅ ICC profile extracted to: ${outputIcc}`);
  } catch (err) {
    console.error("❌ Failed to extract ICC from TIFF:", err.message);
  }
});
