def validate_profile_data(profile_addr):
    target = lldb.debugger.GetSelectedTarget()
    process = target.GetProcess()
    error = lldb.SBError()
    profile_data = process.ReadMemory(profile_addr, 256, error)  # Profile size is assumed to be 256 bytes
    if error.Success():
     profile_size = int.from_bytes(profile_data[0:4], 'big')
     preferred_cmm = profile_data[4:8].decode('ascii')
     print(f"Profile Size: {profile_size}")
     print(f"Preferred CMM: {preferred_cmm}")
    else:
     print(f"Failed to read profile data at {profile_addr}: {error.GetCString()}")

