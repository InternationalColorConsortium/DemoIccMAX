def check_stack_integrity(stack_addr, expected_size):
    target = lldb.debugger.GetSelectedTarget()
    process = target.GetProcess()
    error = lldb.SBError()
    stack_data = process.ReadMemory(stack_addr, expected_size, error)
    if error.Success():
     print("Stack Memory Integrity Check:")
     for i in range(0, len(stack_data), 16):
      chunk = stack_data[i:i+16]
      hex_chunk = ' '.join(f'{b:02x}' for b in chunk)
      ascii_chunk = ''.join(chr(b) if 32 <= b <= 127 else '.' for b in chunk)
      print(f"{stack_addr+i:08x}  {hex_chunk:<48}  {ascii_chunk}")
    else:
     print(f"Failed to read stack memory at {stack_addr}: {error.GetCString()}")

