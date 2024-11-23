
# Ranked Scan-build Report Comparison (Q4|2023-Q3|2024)

**Last Updated: 13 September 2024**

| **Category**                               | **Q4 2023** | **Q2 2024** | **Sep 12, 2024** | **Commit [9373786](https://github.com/InternationalColorConsortium/DemoIccMAX/commit/0f8bc1a0371f1cd26fbe642a0a5a22afe9373786)** | **Change** | **Comments**                                                                                                                             | **Priority** |
|--------------------------------------------|-------------|-------------|-----------------|-----------------|------------|------------------------------------------------------------------------------------------------------------------------------------------|--------------|
| **All Bugs**                               | 113         | 118         | 111             | 111             | -7         | Overall bug count reduced in the latest report, showing improvement in the codebase.                                                     | -            |
| **API**                                    | -           | -           | 5               | 5               | +5         | New category detecting API misuse (null passed where non-null is expected).                                                             | **1**        |
| **Logic Errors**                           |             |             |                 |                 |            |                                                                                                                                          |              |
| Assigned value is garbage or undefined     | 2           | 1           | 1               | 1               | No change  | The assigned value garbage issue remains consistent across the last two reports.                                                         | **2**        |
| Called C++ object pointer is null          | 3           | 2           | 2               | 2               | No change  | No change between Sep 2024 and the latest report, suggesting stability in handling null pointers.                                         | **2**        |
| Dereference of null pointer                | 13          | 14          | 14              | 14              | No change  | Null pointer dereference issues remained the same between the last two reports.                                                          | **1**        |
| Garbage return value                       | 1           | 1           | -               | -               | N/A        | No longer reported in the most recent data.                                                                                              | **4**        |
| Result of operation is garbage or undefined| 4           | 4           | -               | -               | N/A        | No longer reported in the most recent data.                                                                                              | **4**        |
| Uninitialized argument value               | 6           | 3           | 3               | 3               | No change  | Uninitialized arguments remain the same as in the last report.                                                                            | **3**        |
| **Memory Errors**                          |             |             |                 |                 |            |                                                                                                                                          |              |
| Bad deallocator                            | 7           | 6           | 4               | 4               | -2         | Significant improvement in deallocation handling in the latest report.                                                                   | **2**        |
| Double free                                | 2           | 2           | 2               | 2               | No change  | Double free issues remain consistent across all reports.                                                                                 | **1**        |
| Memory leak                                | 10          | 13          | 13              | 13              | No change  | Memory leaks persist in both Sep 2024 and the latest report, requiring attention.                                                        | **1**        |
| Use-after-free                             | 8           | 9           | 9               | 9               | No change  | No new use-after-free errors introduced in the most recent report.                                                                       | **1**        |
| Use of zero allocated                      | -           | 1           | 1               | 1               | No change  | New issue introduced in the Sep 2024 report persists in the latest data.                                                                 | **2**        |
| **Unix API (Memory)**                      |             |             |                 |                 |            |                                                                                                                                          |              |
| Allocator sizeof operand mismatch          | 1           | 1           | 1               | 1               | No change  | No change, suggesting this edge case issue is still unresolved.                                                                          | **2**        |
| **Unused Code**                            |             |             |                 |                 |            |                                                                                                                                          |              |
| Dead assignment                            | 28          | 30          | 30              | 30              | No change  | Dead assignments remain unchanged since the Sep 2024 report.                                                                             | **4**        |
| Dead increment                             | 3           | 4           | 4               | 4               | No change  | No change between Sep 2024 and the latest report.                                                                                        | **5**        |
| Dead initialization                        | 20          | 22          | 21              | 21              | -1         | One dead initialization issue was resolved between the Sep 2024 and latest report.                                                       | **4**        |
| Dead nested assignment                     | 1           | 1           | 1               | 1               | No change  | The dead nested assignment issue remains consistent across all reports.                                                                  | **5**        |

---

### Prioritized Breakdown of Latest Data:

| **Category**                    | **Bug Type**                                  | **Quantity** | **Priority** |
|---------------------------------|-----------------------------------------------|--------------|--------------|
| **All Bugs**                    | Total Bug Count                               | 111          | -            |
| **API Issues**                  | Argument with 'nonnull' attribute passed null | 5            | **1**        |
| **Logic Errors**                | Assigned value is garbage or undefined        | 1            | **2**        |
|                                 | Called C++ object pointer is null             | 2            | **2**        |
|                                 | Dereference of null pointer                   | 14           | **1**        |
|                                 | Uninitialized argument value                  | 3            | **3**        |
| **Memory Errors**               | Bad deallocator                               | 4            | **2**        |
|                                 | Double free                                   | 2            | **1**        |
|                                 | Memory leak                                   | 13           | **1**        |
|                                 | Use of zero allocated                         | 1            | **2**        |
|                                 | Use-after-free                                | 9            | **1**        |
| **Unix API**                    | Allocator sizeof operand mismatch             | 1            | **2**        |
| **Unused Code**                 | Dead assignment                               | 30           | **4**        |
|                                 | Dead increment                                | 4            | **5**        |
|                                 | Dead initialization                           | 21           | **4**        |
|                                 | Dead nested assignment                        | 1            | **5**        |

---

### Explanation of Prioritization:

- **1 (Must Fix)**: Critical issues such as memory leaks, dereferencing null pointers, and API misuse can lead to crashes, security vulnerabilities, or serious bugs in the software.
- **2 (High Priority)**: Important but less critical than group 1; includes problems that could impact performance or stability like bad deallocators, uninitialized values, and size mismatches.
- **3 (Moderate Priority)**: Uninitialized argument values could lead to undefined behavior but may not be as immediate of a risk as memory management issues.
- **4 (Low Priority)**: Unused code such as dead assignments is not directly harmful but should be cleaned up for maintainability and potential optimizations.
- **5 (Would Be Nice)**: Minor issues like dead increments and nested assignments are unlikely to affect performance or stability but should be addressed eventually.
