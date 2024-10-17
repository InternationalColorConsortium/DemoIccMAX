
# track_memory_leak.py

## Overview
Tracks memory allocations to help identify leaks.

## Purpose
This script is part of the LLDB helper scripts designed to enhance the debugging and profiling experience for the DemoIccMAX project.

## Usage
1. Load the script in LLDB:
    ```bash
    command script import /path/to/contrib/lldb/track_memory_leak.py
    ```
    
2. Call the appropriate function from the script as needed within the LLDB session.

## Example
```bash
(lldb) track_memory_leak.py
```
