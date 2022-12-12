# COMPILATION PROJECT
**repository if204-17431**

*Project done by : Jad Elkarchi and Moahmed Seddiq Elalaoui*

This project is a bluit compiler using MYML and compiled to P-code that can be executed or ran by gcc.
MyML is a small functional programming language similar to ML/Haskell, using an Adhoc syntax. 

**We have reached part 7 (Global variables) in our compiler development.**
**The last time we've met with our supervisor we were working on part 4 and part 5 (if then else).**

- [**V**] Part 0 : **Calculator**

- [**V**] Part 1 : **Variable declaration**

- [**V**] Part 2 : **Local declaration and Encapsulation**

- [**V**] Part 3 : **Simple If Then Else statements**

- [**V**] Part 4 : **Nested If Then Else statements**

- [**V**] Part 5 : **Simple function definition**

- [**V**] Part 6 : **Recursive functions**

- [] Part 7 : **Global and Extern variables**

    - - This part is still on development and not fully implemented.



- [] Part 8 : **Variable types**

    - - As far as type management in the MYML syntax is concerned, it is done by inference. The compiler will determine 
    the type of an expression according to the context of use.
    Let's take the following example: 
    ```js
    let y = 1.4*x;
    ```
    before evaluating the expression the variable y would have an undefined type, however after evaluating the expression
    we can infer that y is a float. The infered type will be saved for later purposes, so that when y is encountered in 
    an invalid expression such as: 
    ```js
    y = 'astring';
    ```
    a type error will be thrown at compile time.
    An order among types shall be established as well since for exemple the addition of an integer and a float will be 
    a float. thus for numericals we would propose the following order: ```UNDEFINED < FLOAT < INT```, and we would consider the
    smallest types when evaluating expressions.
    The same principle shall be applied to functions as well, take the factorial function for example, the infered type would
    be a function that takes an integer and returns an integer. However some problems may be encountered with polymorphic
    functions such as the square function:
    ```js
    square(x) = x*x; 
    ``` 
    such a function is both functional for integers and floats 
    and thus cannot be uniquely typed.


In order to run our compiler please follow these steps :

```c
// the makefile can be used to compile, run and test our compiler
// yet another compiler compiler ;)
```

```c
> make 
// calling make in your terminal will build and compile src files
// the output is a myml executable
```

```c
> ./myml yourTest.ml
// the myml executable will compile your .ml file.
// it is mandatory for the file to have a .ml extension
// and should exist in the tst directory.
// running myml without any or invalid input will not work.
// the output of compiling your file will be shown in your current repository.
// A c file will be automatically produced in order to test the P-code produced by myml. 
```

```c
> make test 
// compiles all the .ml files in tst from test1 to test6.
```

```c
> make run
// runs all the .c produced files from test1 to test6 on gcc 
// (no flags).
```

```c
> make clean
// Deletes the build repo and all the output files.
```