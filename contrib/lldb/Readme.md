
## LLDB Helper Scripts for DemoIccMAX Project

This `lldb/` directory contains a collection of LLDB helper scripts designed to enhance the debugging and profiling experience when working with the DemoIccMAX project. These scripts are particularly useful for inspecting memory buffers, stack traces, heap allocations, and other data structures within the project.

### Overview

The scripts provided in this directory can be used to automate common debugging tasks such as checking for buffer overflows, dumping stack traces, inspecting memory allocations, and verifying ICC profile data. The goal is to make the debugging process more efficient and user-friendly, especially when working with large codebases like DemoIccMAX.

#### Available Scripts
- **[analyze_heap_allocations.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/analyze_heap_allocations.py)**: Analyzes heap memory allocations to detect issues like double frees or invalid memory access.
- **[check_buffer.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/check_buffer.py)**: Inspects the contents of a buffer in memory.
- **[check_for_overflow.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/check_for_overflow.py)**: Validates if a buffer exceeds expected bounds.
- **[check_pBuf.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/check_pBuf.py)**: Reads buffer contents for debugging purposes.
- **[check_pBuf_dynamic.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/check_pBuf_dynamic.py)**: Dynamically inspects buffer contents.
- **[check_stack_integrity.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/check_stack_integrity.py)**: Checks for potential stack overflows and corruption.
- **[check_xml_node.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/check_xml_node.py)**: Inspects the contents of XML nodes.
- **[dump_stack_trace.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/dump_stack_trace.py)**: Dumps the current stack trace, useful for backtracking issues.
- **[float32_array.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/float32_array.py)**: Reads and displays arrays of 32-bit floating-point values.
- **[hex_dump.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/hex_dump.py)**: Dumps memory content in a hex view.
- **[inspect_buffer_overflow.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/inspect_buffer_overflow.py)**: Inspects a buffer to check for overflow issues.
- **[inspect_icc_tag.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/inspect_icc_tag.py)**: Inspects a specific ICC profile tag.
- **[inspect_stack_frame_vars.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/inspect_stack_frame_vars.py)**: Displays variables in the current stack frame.
- **[read_profile_header.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/read_profile_header.py)**: Reads and displays ICC profile header data.
- **[read_uint32.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/read_uint32.py)**: Reads unsigned 32-bit integers from memory.
- **[read_xml_attributes.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/read_xml_attributes.py)**: Extracts XML attributes from memory.
- **[track_memory_leak.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/track_memory_leak.py)**: Tracks memory allocations to help identify leaks.
- **[validate_multi_process_element.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/validate_multi_process_element.py)**: Validates multi-process elements in ICC profiles.
- **[validate_profile_data.py](https://github.com/xsscx/PatchIccMAX/tree/development/contrib/lldb/validate_profile_data.py)**: Validates profile data, particularly header fields.

## How to Use

1. **Loading the Scripts**: You can load these helper scripts in LLDB by using the following command:

```
lldb -S /path/to/contrib/lldb/lldb_config.py
```

This will import all scripts automatically, making them accessible within your LLDB session.

2. **Manually Importing Individual Scripts**: You can import individual scripts into an LLDB session using:

```
command script import /path/to/contrib/lldb/<script_name>.py
```

3. **Usage Examples**:
- To inspect a buffer:
  ```
  (lldb) check_buffer 0x7fff5fbff000 64
  ```
- To dump a stack trace:
  ```
  (lldb) dump_stack_trace
  ```
