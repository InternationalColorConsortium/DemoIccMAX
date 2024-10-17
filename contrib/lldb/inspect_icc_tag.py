def inspect_icc_tag(tag_addr):
    target = lldb.debugger.GetSelectedTarget()
    process = target.GetProcess()
    error = lldb.SBError()
    tag_data = process.ReadMemory(tag_addr, 128, error)  # Adjust size based on the tag size
    if error.Success():
     print("Tag Data:")
     for i in range(0, len(tag_data), 8):
      print(f"{i}: {tag_data[i:i+8].hex()}")
    else:
     print(f"Failed to read tag at {tag_addr}: {error.GetCString()}")

