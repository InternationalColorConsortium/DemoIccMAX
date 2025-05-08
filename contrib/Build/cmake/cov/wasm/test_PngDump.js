const fs = require('fs');
const path = require('path');
const createModule = require('./Tools/IccPngDump/iccPngDump.js'); // Adjust path as needed

(async () => {
  const Module = await createModule();

  // Simulate CLI: iccPngDump with no arguments
  try {
    Module.callMain([]);
  } catch (err) {
    console.error('[FAIL] iccPngDump failed:', err);
    process.exit(1);
  }

  console.log('[PASS] iccPngDump smoke test ran with no args (help expected)');
})();
