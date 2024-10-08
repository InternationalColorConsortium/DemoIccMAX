def track_memory_leak(start_address, block_size, num_blocks):
    target = lldb.debugger.GetSelectedTarget()
    process = target.GetProcess()
    error = lldb.SBError()
    for i in range(num_blocks):
     current_address = start_address + (i * block_size)
     block_data = process.ReadMemory(current_address, block_size, error)
     if error.Success():
      print(f"Memory Block {i} at {current_address}:")
      print(f"{block_data[:block_size].hex()}")
     else:
      print(f"Failed to read memory at {current_address}: {error.GetCString()}")

