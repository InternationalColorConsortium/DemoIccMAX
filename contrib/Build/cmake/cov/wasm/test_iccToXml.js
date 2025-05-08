const fs = require("fs");
const createModule = require("./Tools/IccToXml/iccToXml.js");

const argv = process.argv.slice(2);
const inputFile = argv[0] || "test.icc";
const outputFile = argv[1] || "output.xml";

createModule().then((Module) => {
  const input = fs.readFileSync(inputFile);
  Module.FS.writeFile("input.icc", input);

  Module.callMain(["input.icc", "out.xml"]);

  const output = Module.FS.readFile("out.xml", { encoding: "utf8" });
  fs.writeFileSync(outputFile, output);
});
