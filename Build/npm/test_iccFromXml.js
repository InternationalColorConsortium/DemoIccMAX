const fs = require("fs");
const createModule = require("./IccFromXml/iccFromXml.js");

createModule().then(Module => {
  const inputBuffer = fs.readFileSync("argbCalc.xml");
  Module.FS.createDataFile("/", "argbCalc.xml", inputBuffer, true, true);

  try {
    Module.callMain(["argbCalc.xml", "output.icc"]);
  } catch (e) {
    if (e.name !== 'ExitStatus') throw e;
  }

  const outputBuffer = Module.FS.readFile("output.icc");
  fs.writeFileSync("output.icc", outputBuffer);
  console.log("Wrote output.icc:", outputBuffer.length, "bytes");
});
