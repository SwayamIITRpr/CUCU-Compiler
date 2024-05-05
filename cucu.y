%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <math.h>
	#include <string.h>
	#include"lex.yy.c"
	#include<ctype.h>
	#define print fprintf
	#define open fopen
	#define close fclose
	int yyparse();
	void yyerror(const char* msg);
	FILE* fp;
	extern FILE *yyout,*yyin;
	char ch;
	int c=0,flag=0;
	
%}

%{
	int yylex();
	int yywrap(void)
	{
		return 1;
	}
%}

%token INT CHAR COMMA ASG MULTIPLY DIVIDE WHILE IF ELSE DOT LEFTP RIGHTP LEFTB RIGHTB TRUE FALSE SEMI ADD SUBTRACT EQ NE
%union 
{
    int int_val; char *str; 
};

%token <str> ID ARRAY TEXT RETURN
%token <int_val> NUM



%%

begin:  Function {if(!flag)print(fp,"Function end \n"); flag=0;}
    | begin Function {if (!flag)print(fp,"Function end \n"); flag=0;}
    | Decl {print(fp,"\n");}
    ;
    
// Function block 
Function:  Type ID {print(fp,"function-%s \n", $2);} rest 
    ;

rest: LEFTP ALUtil RIGHTP{print(fp,"Function body \n");} CompoundStmt
    |LEFTP ALUtil RIGHTP SEMI {flag=1;print(fp,"Function declaration \n");}
    ;

// Declaration block 
Decl: Type Assignment SEMI 
    | Type ArrUse SEMI 
    | Assignment SEMI 
    | FC SEMI {print(fp,"Function call");}
    | ret SEMI 
    ;

// Assignment block 
Assignment: ID {print(fp,"Variable-%s ", $1);} beginID
    | ArrUse ASG {print(fp," = ");} Assignment
    | NUM {print(fp,"constant-%d ", $1);} COMMA Assignment
    | NUM {print(fp,"constant-%d ", $1);} arithmetic Assignment {print(fp," %c ",ch);}
    | TEXT {print(fp,"TEXT-%s ", $1);}
    | ArrUse arithmetic Assignment {print(fp," %c ",ch);}
    | LEFTP Assignment RIGHTP
    | SUBTRACT LEFTP Assignment RIGHTP  {print(fp," - ");}
    | SUBTRACT NUM {print(fp,"constant-(-%d) ", $2);}
    | SUBTRACT ID {print(fp,"Variable-(-%s) ", $2);}
    | NUM  {print(fp,"constant-%d ", $1);}
    ;

// Function Call Block 
FC : ID LEFTP RIGHTP {print(fp,"funct-%s ", $1);}
    | ID LEFTP Assignment RIGHTP {print(fp,"funct-%s ", $1);}
    ;


beginID: arithmetic Assignment {print(fp," %c ",ch);}
    | COMMA Assignment
    | assg 
    |
;

assg: ASG ArrUse {print(fp," = ");}
    | ASG FC {print(fp," = ");}
    | ASG Assignment {print(fp," = ");}


ArrUse : ARRAY  {print(fp,"array-%s ",$1);}
    ;

// Argument List Utility
ALUtil: ArgList {print(fp,"\n");}
    ;

ArgList:  ArgList COMMA Arg 
    | Arg 
    ; 

Arg:  Type ID {print(fp,"Variable-%s FUNC-ARG ",$2);}
    ;

CompoundStmt:  LEFTB StmtList RIGHTB 
    | Stmt
    ;

StmtList:   StmtList Stmt
    | Stmt
    ;

Stmt:   WhileStmt
    | Decl {if (c==0)print(fp,"\n");}
    | IfStmt
    | SEMI
    ;

arithmetic: ADD {ch='+';}
    |SUBTRACT {ch='-';}
    |MULTIPLY {ch='*';}
    |DIVIDE {ch='/';}

// Loops
WhileStmt1: WHILE {print(fp,"conditional-while body\n");}  LEFTP Expr RIGHTP CompoundStmt {c=0;print(fp,"\nwhile end \n");}
    ;

// If Statement
IfStmt1 : IF {print(fp,"conditional-if ");}  LEFTP Expr RIGHTP {print(fp,"\nif body\n");} CompoundStmt else1 {c=0;print(fp," \nif end \n");}
    ;

else1: ELSE {print(fp,"\nconditional-else Body\n");}  else2 
	|
	;

else2: Stmt 
	| CompoundStmt 

//Expression Block
Expr:
    | Expr NE Expr {print(fp," != ");}
    | Expr EQ Expr {print(fp," == ");}
	| TRUE         {print(fp,"TRUE ");}    
	| FALSE        {print(fp,"FALSE ");} 
    | Assignment
    | ArrUse
    ;

WhileStmt: {c=1;} WhileStmt1;

IfStmt: {c=1;} IfStmt1;

// Type Identifier block 
Type: INT {print(fp,"INT ");}
    | CHAR {print(fp,"CHAR* ");}
    ;
    

ret: RETURN NUM {print(fp,"RETURN %d",$2);}
;

%%

int main(int argc, char *argv[])
{	
     yyin = open(argv[1], "r");
     yyout= open("Lexer.txt","w");
     fp= open("Parser.txt","w");

    if(!yyparse())
        printf("\nCOMPILATION SUCCESSFUL!\n");
    else
        printf("\nCOMPILATION FAILURE!\n");

    close(yyin);
    close(yyout);
    close(fp);
    return 0;
}

void yyerror(const char* msg)
{
    print(fp,"\nLine %d : Error about- %s\n", yylineno, yytext);
}
