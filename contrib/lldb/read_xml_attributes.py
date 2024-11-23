def read_xml_attribute(attribute_addr):
    target = lldb.debugger.GetSelectedTarget()
    process = target.GetProcess()
    error = lldb.SBError()
    attribute_data = process.ReadMemory(attribute_addr, 256, error)  # Assuming max attribute size is 256 bytes
    if error.Success():
     attr_str = attribute_data.decode('ascii', 'ignore').split('\x00')[0]
     print(f"Attribute: {attr_str}")
    else:
     print(f"Failed to read attribute at {attribute_addr}: {error.GetCString()}")

