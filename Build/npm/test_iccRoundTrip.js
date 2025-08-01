const fs = require("fs");
const createModule = require("./IccRoundTrip/iccRoundTrip.js");

const argv = process.argv.slice(2);
const inputFile = argv[0];
const renderingIntent = argv[1] || "1";
const useMpe = argv[2] || "0";

if (!inputFile) {
  console.error("Usage: node iccRoundTrip.js <profile.icc> [rendering_intent=1] [use_mpe=0]");
  process.exit(1);
}

createModule({
  print: (text) => console.log(text),
  printErr: (text) => console.error(text),
}).then((Module) => {
  try {
    const input = fs.readFileSync(inputFile);
    Module.FS.writeFile("input.icc", input);

    const args = [
      "input.icc",
      renderingIntent,
      useMpe
    ];

    Module.callMain(args);
  } catch (err) {
    console.error("iccRoundTrip failed:", err.message);
  }
});
