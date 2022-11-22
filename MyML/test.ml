/* 1. Expressions arythmétiques */

1;

1+2;

1+2*3;

/* 2. Definitions globales */

let x = 1;

let y = 2;

let y = 1 + 2 * x;

2*x+y;

/* 3. Définitions locales possiblement avec masquage / portée / visibilité */

let x = 1;

let x = 2 in x;

let x = 2 in let x = 3 in x;

/* 4. Contrôle */


let x = 10;

if (x > 1) then 1 else 0;

let y = if (x > 1) then x else (3*x);

let z = if (x > 1) then if (y>3) then 0 else 1 else if (y<5) then 2 else 3;

/* 5. Fonctions */

let f(x,y) = x + y;

f(1,2);

let f(x,y) = x + y in f(1,2);

/* 6. Recursions */

x*f(x-1);

let f(x) = if (x > 0) then 1 else (x*f(x-1));


