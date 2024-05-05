%{
    #include <stdio.h>
    #include <string.h>
    #include <math.h>
    #include <string.h>
    #include "y.tab.h"
    #define print fprintf
    extern YYSTYPE yylval;
    
%}

w [a-zA-Z]
digit [0-9]

%%
[ \t]                                   ;
[ \n]                                   { yylineno = yylineno + 1;}
({w}[{w}_{digit}]*)(\[{digit}+\])+      { print(yyout,"ARRAY: %s \n",yytext);      yylval.str = strdup(yytext);      return ARRAY;    }
{digit}+                                { print(yyout,"NUM: %d \n",atoi(yytext));  yylval.int_val = atoi(yytext);   return NUM;      }
[\",\']+(.*?)[\",\']+                   { print(yyout,"TEXT: %s \n",yytext);       yylval.str = strdup(yytext);      return TEXT;     }
";"                                     { print(yyout,"SEMICOLON: %s \n",yytext);  return SEMI;     }
true                                    { print(yyout,"BOOLEAN: true\n");          return TRUE;     }
false                                   { print(yyout,"BOOLEAN: false\n");         return FALSE;    }
"int"                                   { print(yyout,"TYPE: int \n");             return INT;      }
"char *"                                { print(yyout,"TYPE: char * \n");          return CHAR;     }
return                                  { print(yyout,"KEYWORD: return \n");       yylval.str = strdup(yytext);      return RETURN;   }
while                                   { print(yyout,"CONTROL STMT.: while \n");  return WHILE;    }
if                                      { print(yyout,"CONTROL STMT.: if \n");     return IF;       }
else                                    { print(yyout,"CONTROL STMT.: else \n");   return ELSE;     }
","                                     { print(yyout,"COMMA: , \n");              return COMMA;    }
"=="                                    { print(yyout,"EQUALS: == \n");            return EQ;       }
"!="                                    { print(yyout,"NOT EQUALS: != \n");        return NE;       }
"."                                     return DOT;
\/\/.*                                  ; //single-line comments ignored by lexer
\/\*(.*\n)*.*\*\/                       ; //multi-line comments  ignored by lexer
{w}({w}|{digit})*                       { print(yyout,"ID: %s \n",yytext);         yylval.str = strdup(yytext);      return ID;       }
"("                                     { print(yyout,"LEFT PARENTHESIS: %s \n",yytext);                          return LEFTP;    }
")"                                     { print(yyout,"RIGHT PARENTHESIS: %s \n",yytext);                           return RIGHTP;   }
"{"                                     { print(yyout,"LEFT BRACE: %s \n",yytext);     return LEFTB;    }
"}"                                     { print(yyout,"RIGHT BRACE: %s \n",yytext);     return RIGHTB;   }
"+"                                     { print(yyout,"ADD: +\n");                 yylval.str = strdup(yytext);      return ADD;      }
"-"                                     { print(yyout,"SUBTRACT: -\n");           yylval.str = strdup(yytext);      return SUBTRACT;}
"/"                                     { print(yyout,"DIVIDE: /\n");              yylval.str = strdup(yytext);      return DIVIDE;   } 
"*"                                     { print(yyout,"MULTIPLY: *\n");            yylval.str = strdup(yytext);      return MULTIPLY; }
"="                                     { print(yyout,"ASSIGN: =\n");                                                return ASG;      }
.                                       { print(yyout,"\nLine %d : Lexical Error - unrecognised %s\n", yylineno, yytext);printf("\nCOMPILATION FAILED!\n");exit(0); }
%%


