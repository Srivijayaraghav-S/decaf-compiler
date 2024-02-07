#ifndef _H_scanner
#define _H_scanner

#include <stdio.h>

#define MaxIdentLen 31    // Maximum length for identifiers

  
/*   The numbers start at 256 because 0-255 are reserved
 */
typedef enum { 
    T_Void = 256,
    T_Int, T_Double, T_Bool, T_String, T_Class, T_Null, T_Dims, T_Increment, T_Decrement, 
    T_LessEqual, T_GreaterEqual, T_Equal, T_NotEqual, T_And, T_Or,
    T_While, T_For, T_If, T_Else, T_Return, T_Break,
    T_Extends, T_This, T_Implements, T_Interface, T_New, T_NewArray,
    T_Identifier, T_StringConstant, T_IntConstant, T_DoubleConstant,
    T_BoolConstant, T_Print, T_ReadInteger, T_ReadLine, T_Static, T_InstanceOf, T_Switch, T_Case, T_Default, 
    T_NumTokenTypes
} TokenType;


static const char *gTokenNames[T_NumTokenTypes] = {
  "T_Void", "T_Int", "T_Double", "T_Bool", "T_String", "T_Class", "T_Null", "T_Dims", "T_Increment", "T_Decrement", 
  "T_LessEqual", "T_GreaterEqual", "T_Equal", "T_NotEqual",
  "T_And", "T_Or", "T_While", "T_For", "T_If", "T_Else", "T_Return",
  "T_Break", "T_Extends", "T_This", "T_Implements", "T_Interface",
  "T_New", "T_NewArray","T_Identifier", "T_StringConstant",
  "T_IntConstant", "T_DoubleConstant", "T_BoolConstant", "T_Print",
  "T_ReadInteger", "T_ReadLine", "T_Static", "T_InstanceOf", "T_Switch", "T_Case", "T_Default"
};


typedef union {
    int integerConstant;
    bool boolConstant;
    char *stringConstant;
    double doubleConstant;
    char identifier[MaxIdentLen+1]; // +1 for terminating null
} YYSTYPE;

extern YYSTYPE yylval;

extern char *yytext;      // Text of lexeme just scanned


int yylex();              // Defined in the generated lex.yy.c file

void InitScanner();                 // Defined in scanner.l user subroutines
 
#endif
