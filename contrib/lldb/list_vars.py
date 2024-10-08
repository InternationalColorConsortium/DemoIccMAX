import __builtin__  # Ensure we can register globally

def list_all_variables(debugger, command, result, internal_dict):
 print("list_vars command executed.")
 variables_to_check = ["this", "DstVector", "pos", "nVectorSize", "zeroVals", "fpos", "iPos", "x", "invx", "lo", "hi", "i"]
 frame = debugger.GetSelectedTarget().GetProcess().GetSelectedThread().GetSelectedFrame()

 for var_name in variables_to_check:
  var = frame.EvaluateExpression(var_name)
  if var.IsValid():
   print(f"({var.GetTypeName()}) {var_name} = {var.GetValue()}")
  else:
   print(f"Error: variable '{var_name}' is not valid or cannot be accessed.")

# Manually register the function
def __lldb_init_module(debugger, internal_dict):
 debugger.HandleCommand('command script add -f list_vars.list_all_variables list_vars')
 print('The "list_vars" command has been installed.')

