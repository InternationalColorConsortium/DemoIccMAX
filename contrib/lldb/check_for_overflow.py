def check_for_overflow(buffer_addr, size, max_value):
    target = lldb.debugger.GetSelectedTarget()
    process = target.GetProcess()
    error = lldb.SBError()
    data = process.ReadMemory(buffer_addr, size * 2, error)  # 2 bytes per entry
    if error.Success():
     for i in range(size):
      value = int.from_bytes(data[i*2:(i*2)+2], byteorder='little')
      if value > max_value:
       print(f"ERROR: Value {value} at index {i} exceeds the max {max_value}")
    else:
     print(f"Failed to read memory at {buffer_addr}: {error.GetCString()}")

