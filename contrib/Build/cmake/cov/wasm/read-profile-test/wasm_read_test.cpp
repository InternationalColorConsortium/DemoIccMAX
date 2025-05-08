#include <emscripten/bind.h>
#include "IccProfile.h"
#include "IccIO.h"

using namespace emscripten;

class ICCProfileJS {
public:
  ICCProfileJS() : profile(new CIccProfile()), io(nullptr) {}
  ~ICCProfileJS() { delete profile; if (io) delete io; }

  bool readFromBuffer(uintptr_t buffer, size_t length) {
    icUInt8Number* data = reinterpret_cast<icUInt8Number*>(buffer);
    io = new CIccMemIO();
    io->Attach(data, length);
    return profile->Read(io);
  }

  bool hasTag(uint32_t sig) const {
    return profile->FindTag(sig) != nullptr;
  }

private:
  CIccProfile* profile;
  CIccMemIO* io;
};

EMSCRIPTEN_BINDINGS(icc_bindings) {
  class_<ICCProfileJS>("ICCProfileJS")
    .constructor<>()
    .function("readFromBuffer", &ICCProfileJS::readFromBuffer)
    .function("hasTag", &ICCProfileJS::hasTag);
}
