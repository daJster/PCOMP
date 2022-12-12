/* 6. Recursions */

let x = 4;

let f(x) = if (x > 0) then 1 else (x*f(x-1));

/* x*f(x-1); produces a segfault */