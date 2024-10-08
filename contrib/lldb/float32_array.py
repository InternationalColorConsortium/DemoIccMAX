import struct
def read_float32_array(start_address, count):
    target = lldb.debugger.GetSelectedTarget()
    process = target.GetProcess()
    error = lldb.SBError()
    data = process.ReadMemory(start_address, count * 4, error)  # 4 bytes per float
    if error.Success():
     print("Contents of Float32 Array:")
     for i in range(count):
      value = struct.unpack('f', data[i*4:(i*4)+4])[0]  # Unpack as float32
      print(f"Float {i}: {value}")
    else:
     print(f"Failed to read memory at {start_address}: {error.GetCString()}")

