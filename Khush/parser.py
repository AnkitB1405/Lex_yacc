# parser.py
import ply.yacc as yacc
from lexer import tokens, lexer

# Grammar rules

def p_statement(p):
    '''statement : declaration
                 | function_declaration
                 | function_definition'''
    # the action is in the specific rules below

def p_declaration(p):
    'declaration : DATATYPE ID SEMICOLON'
    print("✅ Valid simple data-type declaration")

def p_function_declaration(p):
    'function_declaration : DATATYPE ID LPAREN RPAREN SEMICOLON'
    print("✅ Valid function declaration")

def p_function_definition(p):
    'function_definition : DATATYPE ID LPAREN RPAREN LBRACE RBRACE'
    print("✅ Valid function definition")

def p_error(p):
    if p:
        print(f"❌ Syntax error at token {p.type} ('{p.value}') line {p.lineno}")
    else:
        print("❌ Syntax error at EOF")

parser = yacc.yacc()

if __name__ == "__main__":
    print("Enter Java statement (Ctrl+D to exit). Examples:  int x;   void f();   int add() {}")
    try:
        while True:
            s = input("Input: ").strip()
            if not s:
                continue
            # feed the same input to the lexer used by parser
            # (reset lexer input)
            lexer.input(s)
            parser.parse(s, lexer=lexer)
    except EOFError:
        print("\nExiting.")