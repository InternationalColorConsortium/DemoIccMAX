def validate_multi_process_element(element_addr):
    target = lldb.debugger.GetSelectedTarget()
    process = target.GetProcess()
    error = lldb.SBError()
    element_data = process.ReadMemory(element_addr, 512, error)  # Adjust based on expected element size
    if error.Success():
     for i in range(0, len(element_data), 16):
      value = int.from_bytes(element_data[i:i+4], 'big')
      print(f"Element {i//16}: {value}")
    else:
     print(f"Failed to read multi-process element at {element_addr}: {error.GetCString()}")

