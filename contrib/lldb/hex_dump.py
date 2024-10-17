def hex_dump(start_address, length):
    target = lldb.debugger.GetSelectedTarget()
    process = target.GetProcess()
    error = lldb.SBError()
    data = process.ReadMemory(start_address, length, error)
    if error.Success():
     print("Memory Hex Dump:")
     for i in range(0, len(data), 16):
      chunk = data[i:i+16]
      hex_chunk = ' '.join(f'{b:02x}' for b in chunk)
      ascii_chunk = ''.join(chr(b) if 32 <= b <= 127 else '.' for b in chunk)
      print(f"{i+start_address:08x}  {hex_chunk:<48}  {ascii_chunk}")
    else:
     print(f"Failed to read memory at {start_address}: {error.GetCString()}")

