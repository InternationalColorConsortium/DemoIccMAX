# Research

**Last Updated:** 22-JULY-2025 0000Z by David Hoyt

**Intent:** CICD, Research, Code Coverage, AFL Makefiles

### Build cov

```
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX/
git checkout research
cd contrib/Build/cmake/cov/
bash build.sh
```

### Triples Testing Summary


| **Operating System**         | **Kernel Version**                               | **Architecture**     | **Environment**                       |
|-----------------------------|--------------------------------------------------|----------------------|---------------------------------------|
| Linux (Ubuntu 24.04 LTS)     | Linux Kernel 6.8.0-31-generic (glibc)   | x86_64           | Hyper-V (Iso) |

## Scan Build Summary

| **Field**              | **Value**                          |
|------------------------|--------------------------------------|
| **User**               | xss@xnu.x86                     |
| **Working Directory**  | /opt/pr145/DemoIccMAX/Build   |
| **Command Line**       | make -j12                           |
| **Clang Version**      | Homebrew clang version 20.1.7       |
| **Date**               | Wed Jul 23 06:53:13 2025            |

## Bug Summary

| **Bug Type**                          | **Quantity** |
|----------------------------------------|--------------|
| **All Bugs**                           | 77           |
| **Logic Error**                        |              |
| Dereference of null pointer            | 1            |
| Garbage return value                   | 1            |
| Result of operation is garbage/undefined| 4           |
| Returning null reference               | 1            |
| **Memory Error**                       |              |
| Memory leak                            | 5            |
| Use of zero allocated                  | 2            |
| Use-after-free                         | 3            |
| **Stream Handling Error**              |              |
| Closed stream                          | 1            |
| Invalid stream state                   | 2            |
| Resource leak                          | 3            |
| Stream already in EOF                  | 2            |
| **Unused Code**                        |              |
| Dead assignment                        | 24           |
| Dead increment                         | 4            |
| Dead initialization                    | 22           |
| Dead nested assignment                 | 2            |

---

[The ICC Software License](LICENSE.md)
