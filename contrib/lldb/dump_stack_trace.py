def dump_stack_trace():
    target = lldb.debugger.GetSelectedTarget()
    process = target.GetProcess()
    thread = process.GetSelectedThread()
    frame_count = thread.GetNumFrames()
    print("Stack trace:")
    for i in range(frame_count):
     frame = thread.GetFrameAtIndex(i)
     func_name = frame.GetFunctionName()
     file_name = frame.GetLineEntry().GetFileSpec().GetFilename()
     line_number = frame.GetLineEntry().GetLine()
     print(f"Frame {i}: {func_name} at {file_name}:{line_number}")

