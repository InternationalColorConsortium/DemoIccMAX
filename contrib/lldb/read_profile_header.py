def read_profile_header(start_address):
    target = lldb.debugger.GetSelectedTarget()
    process = target.GetProcess()
    error = lldb.SBError()
    data = process.ReadMemory(start_address, 128, error)  # Assuming the header is 128 bytes
    if error.Success():
     profile_size = int.from_bytes(data[0:4], byteorder='big')
     preferred_cmm_type = data[4:8].decode('ascii', 'ignore')
     profile_version = data[8:12].hex()
     print(f"Profile Size: {profile_size}")
     print(f"Preferred CMM Type: {preferred_cmm_type}")
     print(f"Profile Version: {profile_version}")
    else:
     print(f"Failed to read memory at {start_address}: {error.GetCString()}")

