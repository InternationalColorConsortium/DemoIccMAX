def inspect_stack_frame_vars():
    target = lldb.debugger.GetSelectedTarget()
    thread = target.GetProcess().GetSelectedThread()
    frame = thread.GetSelectedFrame()
    variables = frame.GetVariables(True, True, False, True)  # Get locals, arguments, etc.
    for var in variables:
     print(f"{var.GetName()}: {var.GetValue()}")

