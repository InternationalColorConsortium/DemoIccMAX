def inspect_buffer_overflow(buffer_addr, size, overflow_index):
    target = lldb.debugger.GetSelectedTarget()
    process = target.GetProcess()
    error = lldb.SBError()
    buffer = process.ReadMemory(buffer_addr, size, error)
    if error.Success():
     print(f"Inspecting buffer at {buffer_addr}:")
     for i in range(0, len(buffer), 16):
      chunk = buffer[i:i+16]
      hex_chunk = ' '.join(f'{b:02x}' for b in chunk)
      ascii_chunk = ''.join(chr(b) if 32 <= b <= 127 else '.' for b in chunk)
      overflow_marker = ' <--' if i <= overflow_index < i + 16 else ''
      print(f"{buffer_addr+i:08x}  {hex_chunk:<48}  {ascii_chunk}{overflow_marker}")
    else:
     print(f"Failed to read buffer at {buffer_addr}: {error.GetCString()}")

