# Process Control Library

## ⚠️ Disclaimer

**WARNING:** This software is provided **strictly for educational purposes and legitimate system administration**. Misuse of this code may violate software terms of service, privacy laws, or computer crime statutes in your jurisdiction.

**By using this code, you affirm that:**
- You will only use it on systems you own or have explicit authorization to manage
- You understand the risks of process suspension/resumption
- You accept full legal responsibility for your use of this code
- You will not use it to bypass security measures or violate user privacy

## 📦 Repository Structure

- **Main Branch (C Implementation)**:
  - Production-ready C version with cross-platform compatibility
  - Located in root directory (`ProcessControl.c`)

- **Experimental/ASM Branch**:
  - High-performance x64 assembly implementation
  - Located in `experimental/asm/src/ProcessControl.asm`
  - For research/optimization purposes only

## 📖 Technical Overview

Provides low-level Windows process control through two implementations:

### Core Functions
```c
BOOL SuspendProcess(DWORD pid);  // Suspends all threads of a process
BOOL ResumeProcess(DWORD pid);   // Resumes all threads of a process
