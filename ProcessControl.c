//Windows
#if defined(_M_IX86) || defined(__i386__)
#define _X86_
#elif defined(_M_X64) || defined(__x86_64__)
#define _AMD64_
#elif defined(_M_ARM64) || defined(__aarch64__)
#define _ARM64_
#elif defined(_M_ARM) || defined(__arm__)
#define _ARM_
#else
#error "Unsupported architecture"
#endif
#define WIN32_LEAN_AND_MEAN
#include <handleapi.h>
#include <processthreadsapi.h>
#include <tlhelp32.h>

__declspec(dllexport) BOOL SuspendProcess(DWORD pid)
{
    BOOL result = FALSE;
    DWORD flags[] = { TH32CS_SNAPTHREAD, TH32CS_SNAPTHREAD | TH32CS_SNAPALL };
    for (int i = 0; i < 2; ++i)
    {
        HANDLE hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
        if (hSnapshot == INVALID_HANDLE_VALUE) { continue; }
        THREADENTRY32 te32;
        te32.dwSize = sizeof(THREADENTRY32);
        if (!Thread32First(hSnapshot, &te32))
        { CloseHandle(hSnapshot); return result; }
        do
        {
            if (te32.th32OwnerProcessID == pid)
            {
                HANDLE hThread = OpenThread(THREAD_SUSPEND_RESUME, FALSE, te32.th32ThreadID);
                if (hThread != NULL)
                {
                    SuspendThread(hThread);
                    CloseHandle(hThread);
                    result = TRUE;
                }
            }
        } while (Thread32Next(hSnapshot, &te32));
        CloseHandle(hSnapshot);
        if (result) { return TRUE; }
    }
    return result;
}

__declspec(dllexport) BOOL ResumeProcess(DWORD pid)
{
    BOOL result = FALSE;
    DWORD flags[] = { TH32CS_SNAPTHREAD, TH32CS_SNAPTHREAD | TH32CS_SNAPALL };
    for (int i = 0; i < 2; ++i)
    {
        HANDLE hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
        if (hSnapshot == INVALID_HANDLE_VALUE) { continue; }
        THREADENTRY32 te32;
        te32.dwSize = sizeof(THREADENTRY32);
        if (!Thread32First(hSnapshot, &te32))
        { CloseHandle(hSnapshot); return result; }
        do
        {
            if (te32.th32OwnerProcessID == pid)
            {
                HANDLE hThread = OpenThread(THREAD_SUSPEND_RESUME, FALSE, te32.th32ThreadID);
                if (hThread != NULL)
                {
                    ResumeThread(hThread);
                    CloseHandle(hThread);
                    result = TRUE;
                }
            }
        } while (Thread32Next(hSnapshot, &te32));
        CloseHandle(hSnapshot);
        if (result) { return TRUE; }
    }
    return result;
}

BOOL WINAPI DllMain() { return TRUE; }
