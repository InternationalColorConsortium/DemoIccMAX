def analyze_heap_allocation(allocation_addr, size):
    target = lldb.debugger.GetSelectedTarget()
    process = target.GetProcess()
    error = lldb.SBError()
    heap_data = process.ReadMemory(allocation_addr, size, error)
    if error.Success():
     print(f"Heap Allocation at {allocation_addr}:")
     for i in range(0, len(heap_data), 16):
      chunk = heap_data[i:i+16]
      hex_chunk = ' '.join(f'{b:02x}' for b in chunk)
      ascii_chunk = ''.join(chr(b) if 32 <= b <= 127 else '.' for b in chunk)
      print(f"{allocation_addr+i:08x}  {hex_chunk:<48}  {ascii_chunk}")
    else:
     print(f"Failed to read heap allocation at {allocation_addr}: {error.GetCString()}")

