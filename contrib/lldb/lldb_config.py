import lldb
import os

# Helper function to load a script from a file
def load_script(filename):
    filepath = os.path.join(os.path.dirname(__file__), filename)
    if os.path.exists(filepath):
        lldb.debugger.HandleCommand(f'command script import {filepath}')
        print(f'Loaded script: {filename}')
    else:
        print(f'Script {filename} not found!')

# Setup LLDB environment with helpful settings
def configure_lldb():
    # Enable backtracing with more details
    lldb.debugger.HandleCommand('settings set frame-format "frame #${frame.index}: {${function.name}{${module.file.basename}{${line}}}} [${frame.pc}]"')

    # Set the environment variables (customize as needed)
    lldb.debugger.HandleCommand('settings set target.env-vars PATH=/usr/bin:/bin:/usr/sbin:/sbin')
    print('LLDB environment configured.')

# Import helper scripts from contrib/lldb
def import_helper_scripts():
    load_script('analyze_heap_allocations.py')
    load_script('check_buffer.py')
    load_script('check_for_overflow.py')
    load_script('check_pBuf.py')
    load_script('check_pBuf_dynamic.py')
    load_script('check_stack_integrity.py')
    load_script('check_xml_node.py')
    load_script('dump_stack_trace.py')
    load_script('float32_array.py')
    load_script('hex_dump.py')
    load_script('inspect_buffer_overflow.py')
    load_script('inspect_icc_tag.py')
    load_script('inspect_stack_frame_cars.py')
    load_script('read_profile_header.py')
    load_script('read_uint32.py')
    load_script('read_xml_attributes.py')
    load_script('track_memory_leak.py')
    load_script('validate_multi_process_element.py')
    load_script('validate_profile_data.py')

# Configure LLDB and import helper scripts
def setup():
    configure_lldb()
    import_helper_scripts()

setup()

