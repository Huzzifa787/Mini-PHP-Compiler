%{
#include <stdio.h>
#include "yacc.tab.h"
extern int yyparse(void);
extern int yylex(void);
FILE *identifierptr;  // Declare identifierptr globally
%}

%option yylineno
letter[A-Za-z]
digit [0-9]
del [ \t\n]

%%

"<?php"                           {fprintf(yyout, "<StartPhp, %s>\n", yytext); return(StartPhp);}
"?>"                              {fprintf(yyout, "<EndPhp, %s>\n", yytext); return(EndPhp);}
[i][f]                            {fprintf(yyout, "<Keyword, %s>\n", yytext);  return(IF);}
[e][l][s][e]                      {fprintf(yyout, "<Keyword, %s>\n", yytext);  return(ELSE);}
[e][c][h][o]                      {fprintf(yyout, "<Keyword, %s>\n", yytext);  return(ECHO_P);} 
"function"                        {fprintf(yyout, "<Keyword, %s>\n", yytext);  return(FUN);}
[w][h][i][l][e]                   {fprintf(yyout, "<Keyword, %s>\n", yytext);  return(WHILE);}
[c][l][a][s][s]                   {fprintf(yyout, "<Keyword, %s>\n", yytext);  return(CLASS);}
{letter}*                         {fprintf(yyout, "<FName, %s>\n", yytext);  return(FName);}
"$"_?{letter}({letter}|{digit})*  {fprintf(yyout, "<ID, %s>\n", yytext); fprintf(identifierptr, "<ID, %s>\n", yytext);  return(ID);}
{digit}+                          {fprintf(yyout, "<IL, %s>\n", yytext);  return(IL);}
{digit}+"."{digit}*               {fprintf(yyout, "<FL, %s>\n", yytext);  return(FL);}
'[^\']'                           {fprintf(yyout, "<CL, %s>\n", yytext);}
\"[^\"]*\"                        {fprintf(yyout, "<SL, %s>\n", yytext);  return(SL);}
"["|"{"|"("|")"|"}"|"]"|";"       {fprintf(yyout, "<PUN, %s>\n", yytext);  return yytext[0];}
("//"|"#").*                      {fprintf(yyout, "<SLC, %s>\n", yytext);}
"/*"(.|\n)*"*/"                   {fprintf(yyout, "<MLC, %s>", yytext);}
"<"|">"|"="|"*"|"+"|"/"|"-"|"%"|"."  {fprintf(yyout, "<Operator, %s>\n", yytext);  return yytext[0];}
"<="                              {fprintf(yyout, "<Operator, %s>\n", yytext);  return(LE);}
">="                              {fprintf(yyout, "<Operator, %s>\n", yytext);  return(GE);}
"=="                              {fprintf(yyout, "<Operator, %s>\n", yytext);  return(ET);}
"!="                              {fprintf(yyout, "<Operator, %s>\n", yytext);  return(NE);}
"**"                              {fprintf(yyout, "<Operator, %s>\n", yytext);  return(POW);}
{del}*                                                
. return yytext[0];
%%

int yywrap(void) {}

int main() {
    identifierptr = fopen("Identifier.txt", "w");
    yyin = fopen("input.txt", "r");
    yyout = fopen("token.txt", "a");
    yyparse();
    // Close the files
    fclose(yyout);
    fclose(identifierptr);
    return 0;
}
