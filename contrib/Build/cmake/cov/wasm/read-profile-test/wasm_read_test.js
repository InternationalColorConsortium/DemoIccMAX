const fs = require('fs');
const buffer = fs.readFileSync('test.icc'); // use actual ICC file

const IccWasm = require('./icc.js');

IccWasm().then(Module => {
  const profile = new Module.ICCProfileJS();

  // Allocate and copy buffer into WASM memory
  const ptr = Module._malloc
    ? Module._malloc(buffer.length)
    : Module.asm._malloc(buffer.length); // fallback for modularized

  Module.HEAPU8.set(buffer, ptr);

  const success = profile.readFromBuffer(ptr, buffer.length);
  console.log('Read success:', success);

  const tagSig = 0x64657363; // 'desc'
  console.log(`Has 'desc' tag:`, profile.hasTag(tagSig));

  if (Module._free) Module._free(ptr);
  else Module.asm._free(ptr);
});
