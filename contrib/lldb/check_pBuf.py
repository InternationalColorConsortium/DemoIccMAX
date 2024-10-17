def check_pBuf(start_address, count):
    target = lldb.debugger.GetSelectedTarget()
    process = target.GetProcess()
    error = lldb.SBError()
    data = process.ReadMemory(start_address, count * 2, error)  # 2 bytes per unsigned short
    if error.Success():
     print("Contents of pBuf (unsigned short):")
     for i in range(count):
      value = int.from_bytes(data[i*2:(i*2)+2], byteorder='little', signed=False)
      print(f"Value {i}: {value}")
    else:
        print(f"Failed to read memory at {start_address}: {error.GetCString()}")

