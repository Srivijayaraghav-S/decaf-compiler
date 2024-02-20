/* Auxillary Definitions */

%{
    #include <stdlib.h>
	#include <stdio.h>
   
	static int curLineNum, curColNum;   
   
    #define MAX_IDENTIFIER_LENGTH 31  

    
int flag=1;

enum TokenTypes {
    T_Void = 256,
    T_Int, T_Double, T_Bool, T_String, T_Class, T_Null, T_Dims, T_Increment, T_Decrement, 
    T_LessEqual, T_GreaterEqual, T_Equal, T_NotEqual, T_And, T_Or,
    T_While, T_For, T_If, T_Else, T_Return, T_Break,
    T_Extends, T_This, T_Implements, T_Interface, T_New, T_NewArray,
    T_Identifier, T_StringConstant, T_IntConstant, T_DoubleConstant,
    T_BoolConstant, T_Print, T_ReadInteger, T_ReadLine, T_Static, T_InstanceOf, T_Switch, T_Case, T_Default, 
    T_NumTokenTypes
};

typedef enum { false, true } bool;


typedef union {
    int integerConstant;
    bool boolConstant;
    char *stringConstant;
    double doubleConstant;
    char identifier[MAX_IDENTIFIER_LENGTH+1]; // +1 for terminating null
} YYSTYPE;

YYSTYPE yylval; 

%}


/* Regular Definitions */

WHITESPACE          ([ \t]+)
NEWLINE             (\r|\n|\r\n)
SINGLE_COMMENT      ("//"[^\r\n]*)
BEG_COMMENT         ("/*")
END_COMMENT         ("*/")
IDENTIFIER          ([A-Za-z][A-Za-z0-9_]*)
DEC_INTEGER         ([0-9]+)
HEX_INTEGER         (0[xX][0-9A-Fa-f]+)
INTEGER             ({DEC_INTEGER}|{HEX_INTEGER})
BEG_STRING          (\"[^"\n]*)
STRING              ({BEG_STRING}\")
EXPONENT            ([Ee][+-]?{DEC_INTEGER})
DOUBLE_NUM          ([0-9]+\.[0-9]*)
DOUBLE_SCI          ({DOUBLE_NUM}{EXPONENT})
OPERATOR            ([-+/*%=.,;!<>()[\]{}:])

/* Rules */

%%
 /* Keywords */
{BEG_COMMENT}        { flag=0; }
{END_COMMENT}        { if(flag!=0) fprintf(stderr, "Error: No terminted comment at %d\n", curLineNum);
                       else flag=1;}
<*>{NEWLINE}         { curLineNum++; curColNum=1;}
{SINGLE_COMMENT}            { /* Just ignore until the end of the line */ }
"int"              { if(flag!=0)printf("Token: T_Int Value: %s\n", yytext); } 
"double"           { if(flag!=0)  printf("Token: T_Double Value: %s\n", yytext); }
"bool"             { if(flag!=0)  printf("Token: T_Bool Value: %s\n", yytext);  }
"string"           { if(flag!=0)  printf("Token: T_String Value: %s\n", yytext);;  }
"void"             { if(flag!=0)  printf("Token: T_Void\n"); }
"break"            { if(flag!=0) printf("Token: T_Break\n");  }
"class"            { if(flag!=0) printf("Token: T_Class\n"); }
"else"             { if(flag!=0) printf("Token: T_Else\n");  }
"extends"          { if(flag!=0)printf("Token: T_Extends\n"); }
"for"              { if(flag!=0) printf("Token: T_For\n"); }
"if"               { if(flag!=0) printf("Token: T_If\n");  }
"new"              { if(flag!=0) printf("Token: T_New\n");  }
"null"             { if(flag!=0) printf("Token: T_Null\n");  }
"return"           { if(flag!=0) printf("Token: T_Return\n");  }
"this"             { if(flag!=0) printf("Token: T_This\n");  }
"while"            { if(flag!=0) printf("Token: T_While\n");  }
"static"           { if(flag!=0) printf("Token: T_Static\n");  }
"Print"            { if(flag!=0) printf("Token: T_Print\n"); }
"ReadInteger"      { if(flag!=0) printf("Token: T_ReadInteger\n");  }
"ReadLine"         { if(flag!=0) printf("Token: T_ReadLine\n");  }
"instanceof"       { if(flag!=0) printf("Token: T_InstanceOf\n");  }
"NewArray"         { if(flag!=0) printf("Token: T_NewArray\n");  }
"implements"       { if(flag!=0) printf("Token: T_Implements\n");  }
"interface"        { if(flag!=0) printf("Token: T_Interface\n");  }
"switch"           { if(flag!=0) printf("Token: T_Switch\n"); }
"case"             { if(flag!=0) printf("Token: T_Case\n");  }
"default"          { if(flag!=0) printf("Token: T_Default\n"); }
"<="               { if(flag!=0) printf("Token: T_LessEqual\n");  }
">="               { if(flag!=0) printf("Token: T_GreaterEqual\n");  }
"=="               { if(flag!=0) printf("Token: T_Equal\n"); }
"!="               { if(flag!=0) printf("Token: T_NotEqual\n"); }
"&&"               { if(flag!=0) printf("Token: T_And\n");  }
"||"               { if(flag!=0) printf("Token: T_Or\n"); }
"[]"               { if(flag!=0) printf("Token: T_Dims\n");  }
"++"               { if(flag!=0) printf("Token: T_Increment\n"); }
"--"               { if(flag!=0) printf("Token: T_Decrement\n");  }
{OPERATOR}         { if(flag!=0) printf("Token: T_Operator, Value: %s\n", yytext);  }
{WHITESPACE}        ; /* Ignore whitespace */
"true"              { yylval.boolConstant = (yytext[0]=='t'); if(flag!=0) printf("T_BoolConstant\n"); }
"false"             { yylval.boolConstant = (yytext[0]=='t');  if(flag!=0) printf("T_BoolConstant\n"); }
{DEC_INTEGER}       { yylval.integerConstant = strtol(yytext, NULL, 10); if(flag!=0) printf("T_IntConstant Value: %s\n", yytext); }
{HEX_INTEGER}       { yylval.integerConstant = strtol(yytext, NULL, 16); if(flag!=0) printf("T_IntConstant Value: %s\n", yytext); }
{DOUBLE_NUM}        { yylval.doubleConstant = atof(yytext);  if(flag!=0) printf("T_DoubleConstant Value: %s\n", yytext); }
{DOUBLE_SCI}        { yylval.doubleConstant = atof(yytext); if(flag!=0) printf("T_DoubleConstant Value: %s\n", yytext); }
{STRING}            { yylval.stringConstant = strdup(yytext); if(flag!=0) printf("T_StringConstant Value: %s\n", yytext); }
{BEG_STRING}        { fprintf(stderr, "Error: No terminted string at %d\n", curLineNum); }
{IDENTIFIER} {
    if (yyleng > MAX_IDENTIFIER_LENGTH) {
        fprintf(stderr, "Error: Identifier too long at line at %d\n", curLineNum);
    } else {
        if(flag!=0) 
        {
        printf("Token: T_Identifier Value:%s\n", yytext);
        }
    }
}

.                   { fprintf(stderr, "Error: Unrecognized character at %d\n", curLineNum); }

%%


int main(int argc, char **argv)
{
FILE *file;
file=fopen("example.txt","r");
if(!file)
{
printf("could not open the file");
exit(0);
}
yyin=file;
yylex();
fclose(file);
if (flag == 0) {
        fprintf(stderr, "Error: Unterminated comment at end of file\n");
        return 1; // Return error code
    }
printf("\n");
return(0);
}
int yywrap()
{
return(1);
}



