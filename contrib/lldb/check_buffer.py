def check_buffer(buffer_addr, size, expected_max):
    target = lldb.debugger.GetSelectedTarget()
    process = target.GetProcess()
    error = lldb.SBError()
    data = process.ReadMemory(buffer_addr, size * 2, error)
    if error.Success():
     print("Checking contents of pBuf:")
     for i in range(size):
      value = int.from_bytes(data[i*2:(i*2)+2], byteorder='little')
      if value > expected_max:
       print(f"ERROR: Value {value} at index {i} exceeds the expected max {expected_max}")
     else:
      print(f"Value {i}: {value}")
    else:
        print(f"Failed to read memory at {buffer_addr}: {error.GetCString()}")

