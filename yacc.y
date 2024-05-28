%{
    #include<stdio.h>
    #include<stdlib.h>
    extern int yylineno;
%}
%token StartPhp EndPhp ID IL FL SL LE GE ET NE POW IF ELSE FUN FName WHILE ECHO_P CLASS

%%

ProgramBlock: StartPhp StmtList EndPhp  {printf("Code Compiled Successfully");  exit(0);} 

StmtList : Stmt StmtList 
              | 
              ;

Stmt 	: DecStmt 
          | BoolExp
          | RepStmt
          | DecStruct
          | OutStmt
          | FuncStmt
	  | ClassStmt; 
          

DecStmt: ID '=' RHS ';';
RHS: Value OP RHS
   | Value;
Value: IL 
     | FL 
     | SL 
     | ID;
OP: '+'
  | '-'
  | '*'
  | POW
  | '/';


BoolExp: Exp '>' Exp  { $$ = $1 > $3; }
       | Exp '<' Exp  { $$ = $1 < $3; }
       | Exp ET Exp   { $$ = $1 == $3; }
       | Exp NE Exp   { $$ = $1 != $3; }
       | Exp GE Exp   { $$ = $1 >= $3; }
       | Exp LE Exp   { $$ = $1 <= $3; }
       ;
Exp: IL;       


RepStmt: WHILE '(' BoolExp ')' '{' StmtList '}';


DecStruct: IF '(' BoolExp ')' '{' StmtList '}'
         | IF '(' BoolExp ')' '{' StmtList '}' ELSE '{' StmtList '}';
 

OutStmt: ECHO_P Output ';' ;
Output: SL
       | ID 
       | SL '.' ID '.' SL;


FuncStmt: FuncDec
	| FuncCall
	;
FuncDec: FUN FName '(' ArgList ')' '{' StmtList '}';
FuncCall: FName '(' ArgList ')' ';' ;
ArgList:
       | ArgList ',' ID
       | ArgList ',' SL
       | ArgList ',' IL
       | ArgList ',' FL
       | ID
       | SL
       | IL
       | FL
       ;
ClassStmt: CLASS FName '{' ClassStmtList '}';
ClassStmtList: DecStmt ClassStmtList
	     | FuncStmt ClassStmtList
	     |
	     ;


%%
void yyerror(const char *str)
{
  printf("Code cannot be compiled\n");
  fprintf(stderr,"Error type: %s\n",str);
  fprintf(stderr,"Line number: %d\n",yylineno);
}