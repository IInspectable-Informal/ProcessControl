; ProcessControl.asm - Minimal x64 version
option casemap:none

; Constants
INVALID_HANDLE_VALUE     equ -1
TH32CS_SNAPTHREAD       equ 4
TH32CS_SNAPALL          equ 15
THREAD_SUSPEND_RESUME   equ 2
TRUE                    equ 1
FALSE                   equ 0

; Structure definition
THREADENTRY32 struct
    dwSize              dd ?
    cntUsage            dd ?
    th32ThreadID        dd ?
    th32OwnerProcessID  dd ?
    tpBasePri           dd ?
    tpDeltaPri          dd ?
    dwFlags             dd ?
THREADENTRY32 ends

; Import addresses
extern CreateToolhelp32Snapshot:proc
extern Thread32First:proc
extern Thread32Next:proc
extern OpenThread:proc
extern SuspendThread:proc
extern ResumeThread:proc
extern CloseHandle:proc

.data
te32 THREADENTRY32 {}

.code

SuspendProcess proc
    mov rdx, TRUE
    push rbx
    push rsi
    push rdi
    sub rsp, 40h
    
    mov rsi, rcx        ; save pid
    mov edi, edx        ; save suspend flag
    
    ; flags array
    mov dword ptr [rsp+20h], TH32CS_SNAPTHREAD
    mov dword ptr [rsp+24h], TH32CS_SNAPTHREAD or TH32CS_SNAPALL
    
    xor ebx, ebx        ; result = FALSE
    xor r15d, r15d      ; i = 0
    
flags_loop:
    cmp r15d, 2
    jge done
    
    ; CreateToolhelp32Snapshot
    mov ecx, [rsp+20h + r15*4]
    xor edx, edx
    call CreateToolhelp32Snapshot
    mov r14, rax        ; hSnapshot
    cmp rax, INVALID_HANDLE_VALUE
    je next_iteration
    
    ; Initialize THREADENTRY32
    mov te32.dwSize, sizeof THREADENTRY32
    
    ; Thread32First
    lea rdx, te32
    mov rcx, r14
    call Thread32First
    test rax, rax
    jz close_snapshot
    
thread_loop:
    ; Check owner process
    mov eax, te32.th32OwnerProcessID
    cmp eax, esi
    jne next_thread
    
    ; OpenThread
    mov r8d, te32.th32ThreadID
    xor edx, edx
    mov ecx, THREAD_SUSPEND_RESUME
    call OpenThread
    test rax, rax
    jz next_thread
    
    mov r13, rax        ; hThread
    
    mov rcx, rax
    call SuspendThread
    jmp after_op
    
after_op:
    ; Close thread handle
    mov rcx, r13
    call CloseHandle
    
    mov ebx, TRUE       ; result = TRUE
    
next_thread:
    ; Thread32Next
    lea rdx, te32
    mov rcx, r14
    call Thread32Next
    test rax, rax
    jnz thread_loop
    
close_snapshot:
    ; Close snapshot
    mov rcx, r14
    call CloseHandle
    
    test ebx, ebx
    jnz done
    
next_iteration:
    inc r15d
    jmp flags_loop
    
done:
    mov eax, ebx
    add rsp, 40h
    pop rdi
    pop rsi
    pop rbx
    ret
SuspendProcess endp

ResumeProcess proc
    mov rdx, FALSE
    push rbx
    push rsi
    push rdi
    sub rsp, 40h
    
    mov rsi, rcx        ; save pid
    mov edi, edx        ; save suspend flag
    
    ; flags array
    mov dword ptr [rsp+20h], TH32CS_SNAPTHREAD
    mov dword ptr [rsp+24h], TH32CS_SNAPTHREAD or TH32CS_SNAPALL
    
    xor ebx, ebx        ; result = FALSE
    xor r15d, r15d      ; i = 0
    
flags_loop:
    cmp r15d, 2
    jge done
    
    ; CreateToolhelp32Snapshot
    mov ecx, [rsp+20h + r15*4]
    xor edx, edx
    call CreateToolhelp32Snapshot
    mov r14, rax        ; hSnapshot
    cmp rax, INVALID_HANDLE_VALUE
    je next_iteration
    
    ; Initialize THREADENTRY32
    mov te32.dwSize, sizeof THREADENTRY32
    
    ; Thread32First
    lea rdx, te32
    mov rcx, r14
    call Thread32First
    test rax, rax
    jz close_snapshot
    
thread_loop:
    ; Check owner process
    mov eax, te32.th32OwnerProcessID
    cmp eax, esi
    jne next_thread
    
    ; OpenThread
    mov r8d, te32.th32ThreadID
    xor edx, edx
    mov ecx, THREAD_SUSPEND_RESUME
    call OpenThread
    test rax, rax
    jz next_thread
    
    mov r13, rax        ; hThread
    
    mov rcx, rax
    call ResumeThread
    jmp after_op
    
after_op:
    ; Close thread handle
    mov rcx, r13
    call CloseHandle
    
    mov ebx, TRUE       ; result = TRUE
    
next_thread:
    ; Thread32Next
    lea rdx, te32
    mov rcx, r14
    call Thread32Next
    test rax, rax
    jnz thread_loop
    
close_snapshot:
    ; Close snapshot
    mov rcx, r14
    call CloseHandle
    
    test ebx, ebx
    jnz done
    
next_iteration:
    inc r15d
    jmp flags_loop
    
done:
    mov eax, ebx
    add rsp, 40h
    pop rdi
    pop rsi
    pop rbx
    ret
ResumeProcess endp

DllMain proc
    mov eax, 1
    ret
DllMain endp

end
