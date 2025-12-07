# Advent of Assembly 2025!!

Wanted to give advent of code a try in assembly this year.

These binaries are for my M1 mac, so they are ARMv8 (aarch64), and follow the MacOS-specific calling conventions, and have some weirdness with being compatible with Mach-O.
Notably this changes variadic args and how you have to link pointers (to .data e.g.) into registers. 

This does depend on libc & the c runtime because I'm not that based.

## Links (for myself mostly):
- [Awesome intro](https://developer.arm.com/-/media/Arm%20Developer%20Community/PDF/Learn%20the%20Architecture/Armv8-A%20Instruction%20Set%20Architecture.pdf)
- [Cheat sheet of questionable accuracy](https://courses.cs.washington.edu/courses/cse469/19wi/arm64.pdf)
- [Arm site instruction reference](https://developer.arm.com/documentation/ddi0487/lb/?lang=en)
- [MKW thing I should have read](https://mariokartwii.com/armv8/)
- [Good apple silicon-specific tidbits](https://github.com/below/HelloSilicon)
- [Official apple asm info](https://developer.apple.com/documentation/xcode/writing-arm64-code-for-apple-platforms)
