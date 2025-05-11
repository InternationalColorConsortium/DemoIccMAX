[![color.org logo](ReadMeFiles/ICC_header.png "color.org")](https://color.org)

# Research

**Last Updated:** 11-MAY-2025 1200Z

**Intent:** Code Coverage & AFL Makefiles

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

### Fuzzing Gates

**CICD Research**

	
| **Bug Type**     | **Sub-Type**                      | **START** | **CURRENT** |
|------------------|-----------------------------------|--------------------|----------------------|
| **All Bugs**     |                                   | 67                 | 47                    |
| **Logic Error**  | Assigned value is garbage         | 1                  | -                    |
|                  | Dereference of null pointer       | 1                  | -                    |
|                  | Garbage return value              | 1                  | -                    |
|                  | Result of op is garbage/undefined | 4                  | -                    |
|                  | Uninitialized argument value      | 3                  | -                    |
| **Memory Error** | Double delete                     | 1                  | -                    |
|                  | Memory leak                       | 1                  | -                    |
|                  | Use of zero allocated             | 1                  | -                    |
|                  | Use-after-free                    | 2                  | -                    |
| **Unused Code**  | Dead assignment                   | 24                 | 21                   |
|                  | Dead increment                    | 4                  | 4                    |
|                  | Dead initialization               | 22                 | 20                   |
|                  | Dead nested assignment            | 2                  | 2                    |

**Known Bugs**

| **Bug Type**     | **Sub-Type**                      | **START** | **CURRENT** |
|------------------|-----------------------------------|--------------------|----------------------|
| **All Bugs**     |                                   | 874                 | 848                 |
| **Other**        | Code Review, CodeQL Bugs          | 860                 | 840                 |
| **Heap or Stack**  | Over, Under, Other              | 14                  | 8                   |

---

[The ICC Software License](LICENSE.md)
