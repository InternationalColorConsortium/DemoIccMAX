def check_xml_node(node_address):
    target = lldb.debugger.GetSelectedTarget()
    process = target.GetProcess()
    error = lldb.SBError()
    node = process.ReadMemory(node_address, 64, error)  # Adjust size based on expected node size
    if error.Success():
     print("XML Node Contents:")
     for i in range(0, len(node), 8):
      print(f"{i}: {node[i:i+8].hex()}")
    else:
     print(f"Failed to read XML node at {node_address}: {error.GetCString()}")

