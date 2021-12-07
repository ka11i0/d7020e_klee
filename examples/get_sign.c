/*
 * First KLEE tutorial: testing a small function
 * https://klee.github.io/tutorials/testing-function/
 */

#include <klee/klee.h>

int get_sign(int x)
{
    if (x == 0)
        return 0;

    if (x < 0)
        return -1;
    else
        return 1;
}

int main()
{
    int a;
    klee_make_symbolic(&a, sizeof(a), "a");
    int b = 1000 / (a + 5);
    return get_sign(a);
}

// A) Compiling into LLVM bitcode
// > clang -emit-llvm -c get_sign.c
//
// Now you can run Klee on your generated bitcode.
//
// > klee get_sign.bc
//
// Answer: Divide by zero error caught!
//
// B) Inspecting the output
//
// > ls klee-last/
//
// Answer: assembly.ll  info  messages.txt  run.istats  run.stats  test000001.div.err ...
//
// C) Inspecting the generated test cases
//
// > ktest-tool klee-last/test000001.ktest
//
// What path in the code does this test represent?
//
// Answer: It represents the path which generates the divide by zero.
//
// > ktest-tool klee-last/test000002.ktest
//
// What path in the code does this test represent?
//
// Answer: The path where get_sign reaches the else condition
//
// > ktest-tool klee-last/test000003.ktest
//
// What path in the code does this test represent?
//
// Answer: The path where get_sign reaches the if(x==0) condition
//
// D) Replaying a test case
//
// Fist check that includes were installed:
// > ls /usr/local/include
// klee
//
// > ls /usr/local/lib
// klee  libkleeRuntest.so  libkleeRuntest.so.1.0
//
// If you installed Klee using the package manager
// the path might be different:
//
// Using `aur` (arch) files are stored in the system default
// folders, `/usr/include` and `/usr/lib`.
//
// If those are ok, then you can compile for replay:
//
// > clang -I /usr/local/include/ -L /usr/local/lib get_sign.c -l kleeRuntest
//
// Or just
// > clang get_sign.c -l kleeRuntest
//
// If the `include` and `lib` paths are the system defaults.
//
// To replay the first test:
//
// We need to add the libary path so it can be dynamically loaded:
// Depending on shell this might look different:
//
// Under `bash` (and `bash` like shells)
// > export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
//
// Under `fish`
// > set -x LD_LIBRARY_PATH /usr/local/lib/:$LD_LIBRARY_PATH
//
// Once again, if using the system default system folders
// you don't need to add anything to `LD_LIBRARY_PATH`.
//
// > KTEST_FILE=klee-last/test000001.ktest ./a.out
//
// Now let's inspect the status (return code), in `bash`:
// $? is the return value (error code) as seen by the shell.
//
// > echo $?
//
// In `fish` you would do
//
// > echo $status
//
// Did the result correspond to the expected path for the test?
//
// Answer: Output = 136 = 10001000 = -120 signed? doesn't really make sense
//
// > KTEST_FILE=klee-last/test000002.ktest ./a.out
//
// Inspect the return code:
//
// Did the result correspond to the expected path for the test?
//
// Answer: Output = 1, yes makes sense, 1 takes the execution to else.
//
// > KTEST_FILE=klee-last/test000003.ktest ./a.out
//
// Inspect the return code:
//
// Did the result correspond to the expected path for the test?
//
// Answer: Output = 0, which is the correct path.
//
// Why not? Confer to shell error codes:
//
// Answer: ... assumingly this is for test000001.ktest it could be because divby0 is undefined and KLEE might just put something there.
//
// D) Debugging
//
// In the above example its kind of hard to see exactly
// what happens. Using `gdb` you single step the program.
//
// First build it with debug symbols (`-g`).
// > clang -g -I /usr/local/include/ -L /usr/local/lib get_sign.c -l kleeRuntest
//
// Or if using system defaults:
// > clang -g get_sign.c -l kleeRuntest
//
// Then start `gdb`:
// > KTEST_FILE=klee-last/test000001.ktest gdb ./a.out
// (gdb) break get_sign
//
// (gdb) run
//
// Now we can inspect the `x` argument by:
// (gdb) print x
//
// What value do you get, and why?
//
// Answer: Not possible because "Program terminated with signal SIGFPE", print a gives -5.
//
// Step the code
// > (gdb) next
//
// What path did it take, and why?
//
// "Program terminated with signal SIGFPE" path for div by 0. -5
//
// Now we can try with another test:
//
// (gdb) set environment KTEST_FILE=klee-last/test000002.ktest
//
// And (re-start) the debug session:
// (gdb) run
//
// Step through the code.
//
// Which path did it take, and why?
//
// Answer: (x<0), because x = 1000000000000000000000000000000
//
// And finally:
//
// (gdb) set environment KTEST_FILE=klee-last/test000003.ktest
//
// Which path did it take, and why?
//
// Answer: (x==0), because x = 0
//
// E) Under the hood.
//
// Explain in your own words how
// `klee_make_symbolic(&a, sizeof(a), "a");`
// works when you run `klee` to generate test cases:
//
// Answer: It tells klee what part in memory to treat as symbolic by giving the address &a and size of 
// (hint, mark memory region as symbolic)
//
// Explain in your own words how
// `klee_make_symbolic(&a, sizeof(a), "a");`
// works when you replay test cases:
//
// Answer: When we replay we use the .ktest files which contains 
// information about the symbolic variables for the different cases
// made by `klee_make_symbolic(&a, sizeof(a), "a");`
// (hint, KTEST_FILE points to a concrete assignment
// of the memory region)
