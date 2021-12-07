// array.rs
// Showcase how we automatically can interface Rust to KLEE
//

#![no_std]
#![no_main]

use klee_sys::klee_make_symbolic;
use panic_klee as _;

fn sum_first_elements(arr: &[u8], index: usize) -> u16 {
    let mut acc = 0;
    for i in 0..index {
        if i>arr.len()-1 {
            break;
        }
        acc += arr[i as usize] as u16;
    }
    acc
}

#[no_mangle]
fn main() {
    let mut arr = [0u8; 8];
    let mut i: usize = 0;
    klee_make_symbolic!(&mut i, "i");
    klee_make_symbolic!(&mut arr, "arr");
    let b = sum_first_elements(&arr, i);
}

// A) Array indexing is tricky to analyse at compile time.
// Thus Rust (rustc) will inject code for run-time verification
// `panic`ing on index out of range.
//
// (Compare to C/C++, where a "buffer overflow" might pass unnoticed
// causing all sorts of problems.)
//
// Compare the test generated in release `--release` (optimized) to
// test generated in debug/dev mode (un-optimized).
// DEBUG:
// KLEE: done: total instructions = 4323
// KLEE: done: completed paths = 9
// KLEE: done: partially completed paths = 1
// KLEE: done: generated tests = 10
// 
// RELEASE:
// KLEE: done: total instructions = 34
// KLEE: done: completed paths = 1
// KLEE: done: partially completed paths = 1
// KLEE: done: generated tests = 2
//
// Try to explain in your own words the difference and why?
// (Hint, even if we don't use the result `b`, Rust do not optimize out the call, why?)
//
// Answer: Less instructions in release mode because of optimization.
// Completed paths - My guess is that optimization "removes" the summation because the answer will be 0 for all cases of i.
// Partially completed paths = 1 because of same abort failure.
// Generated tests = completed paths + partially completed paths.
//
// B) Fix the code so that you don't get an error.
// (It should still compute the sum of the n first elements
// and return the sum of the whole array if index larger than size/length).
// The fix should be in the function (not on the caller side).
//
// [Git commit "Array B"]
//
// C) In the example, the array is holding only zeroes.
// Figure out a way to make the content symbolic.
// Hints: declare as mutable, you can set the whole array symbolic.
//
// [Git commit "Array C"]
//
// D) Analyze the example using KLEE. Now a new (maybe unexpected) error should occur!
// Notice, the error occurs only in `debug/dev` builds.
//
// Explain what caused the error.
//
// [Git commit "Array D"]
//
// Answer: Return of u8 can "overflow" in release mode, but debug mode will hinder that.
//
// E) Make a sensible fix to the code.
// Motivate your choice.
//
// Answer: Typecast to u16 fixes the wraparound.
//
// [Git commit "Array E"]
//
// F) Learning outcome.
// In this small exercise we have used KLEE to find errors in our code.
// For such small examples you may spot the errors by "eye".
// The problem however becomes increasingly difficult with increased code size.
// In industry it is expected 15-50 errors per 1000 delivered lines of code.
//
// KLEE analysis ensures "defined behavior", thus Rust code passing KLEE
// without errors is ensured to be free of run-time panics.
//
// Describe in your own words how that improves robustness and reliability.
//
// Answer: Less errors leads to less bad outcome(crashes, etc),
// which in turn means that we have a more robust and reliable system.
//
// [Git commit "Array F"]
