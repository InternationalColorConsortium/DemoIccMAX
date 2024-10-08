def read_uint32(start_address, count):
    target = lldb.debugger.GetSelectedTarget()
    process = target.GetProcess()
    error = lldb.SBError()
    data = process.ReadMemory(start_address, count * 4, error)
    if error.Success():
        for i in range(count):
            value = int.from_bytes(data[i*4:(i*4)+4], byteorder='little')
            print(f"Value {i}: 0x{value:08x}")
    else:
        print(f"Failed to read memory at address {start_address}: {error.GetCString()}")

