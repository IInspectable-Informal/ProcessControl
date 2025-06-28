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
  - Located in `src/ProcessControl.asm`
  - For research/optimization purposes only

## 📖 Technical Overview

Provides low-level Windows process control through two implementations:

### Core Functions
```c
BOOL SuspendProcess(DWORD pid);  // Suspends all threads of a process
BOOL ResumeProcess(DWORD pid);   // Resumes all threads of a process
```

### Key Differences
| Feature          | C Version               | ASM Version               |
|------------------|-------------------------|---------------------------|
| Architecture     | Multi-arch compatible  | x64 optimized            |
| Stability        | Production-ready       | Experimental            |
| Use Case        | General purpose        | Performance-critical    |

## ⚠️ Ethical Usage Notice

**This software is NOT intended for:**
- Bypassing license checks or DRM
- Game cheating or hacking
- Unauthorized process manipulation
- Any illegal or unethical activity

**Recommended use cases:**
- Legitimate debugging tools
- Authorized system administration
- Academic research (with oversight)

## 📜 License (GPL-3.0)

This project is licensed under the **GNU General Public License v3.0**. This means:
- You may use, modify and distribute the software
- You must disclose source code for any derivatives
- Derivatives must use the same license
- No warranty is provided

Full license text: [LICENSE](LICENSE)

## 🛠️ Building

**C Version (Main Branch):**
```bash
gcc -shared -o ProcessControl.dll ProcessControl.c
```

**ASM Version (Experimental):**
```bash
nasm -f win64 ProcessControl.asm -o ProcessControl.obj
link /dll /out:ProcessControl.dll ProcessControl.obj
```

## 🙋 Support

For legitimate usage questions:  
[Open an Issue](https://github.com/IInspectable-Informal/ProcessControl/issues)

**Developer Note:** This tool demonstrates low-level Windows APIs - use this knowledge responsibly.
