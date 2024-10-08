def check_pBuf_dynamic():
    frame = lldb.debugger.GetSelectedTarget().GetProcess().GetSelectedThread().GetSelectedFrame()
    pBuf = frame.FindVariable("pBuf")
    buffer_addr = pBuf.GetValueAsUnsigned()
    size = 4096
    expected_max = 65535
    print(f"Checking buffer at address: 0x{buffer_addr:x}")
    check_buffer(buffer_addr, size, expected_max)

