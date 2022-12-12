%option noyywrap
/* avoid dependency with library fl */

%{ 
#include "../build/y.tab.h"
#include "../src/hdr/Table_des_symboles.h"
#include <stdio.h>

%}

whitespace          [ \t\r\n\f]+

digit               [0-9]
alpha               [a-zA-Z]
alphanum            [a-zA-Z0-9]

integer             [[:digit:]]+
float               [[:digit:]]+\.[[:digit:]]*
boolean             "true"|"false"

escape              \\([\\"'ntbr ])
string              \"({escape}|[^"\\])*\"

all_but_star        []


identifier          [[:alpha:]][[:alnum:]]*

%% 
"/*".*"*/"   /* commentaire en ML */
"++"         {return CONCAT;}
"+"          {return PLUS;}
"-"          {return MOINS;}
"*"          {return MULT;}
"/"          {return DIV;}
"="          {return EQ;}
"<"          { yylval.val_comp = "LT"; /*storing the sign of the comp in val_comp*/ return ISLT;} 
">"          { yylval.val_comp = "GT"; return ISGT;}
"<="         { yylval.val_comp = "LEQ"; return ISLEQ;}
">="         { yylval.val_comp = "GEQ"; return ISGEQ;}
"=="         { yylval.val_comp = "EQ"; return ISEQ;}

"let"        {return LET;}
"in"         {return IN;}
"if"         {return IF;}
"then"       {return THEN;}
"else"       {return ELSE;}


{boolean}    {return BOOL;}

"("          {return LPAR;}
")"          {return RPAR;}
","          {return VIR;}
";"          {return PV;}

{float}      {
    yylval.val_fl = atof(yytext); // turning the yytext to float and affecting it to val_fl
    return FLOAT;
}

{integer}    {
    yylval.val_int = atoi(yytext); // turning the yytext to int and affecting it to val_int
    return NUM; 
}

{identifier} {
    yylval.val_id = string_to_sid(yytext); // turning the yytext to sid and affecting it to val_id
    return ID;
}

{string}     {
    yylval.val_str = yytext; // affecting yytext direclty to val_str
    return STRING;
}

{whitespace} ;
