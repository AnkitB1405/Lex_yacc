import ply.yacc as yacc
from lexer import tokens, lexer

# Grammar rules - simplified and conflict-free

def p_program(p):
    '''program : statement_list
               | empty'''
    print("✓ Parse successful!")

def p_statement_list(p):
    '''statement_list : statement
                      | statement_list SEMICOLON statement
                      | statement_list statement'''
    pass

def p_statement(p):
    '''statement : command
                 | if_statement
                 | for_loop
                 | assignment
                 | expression'''
    pass

def p_command(p):
    '''command : ID
               | ID arg_list
               | ID arg_list redirect
               | ID redirect'''
    print(f"Command recognized: {p[1]}")

def p_arg_list(p):
    '''arg_list : argument
                | arg_list argument'''
    pass

def p_argument(p):
    '''argument : ID
                | NUMBER
                | STRING'''
    pass

def p_redirect(p):
    '''redirect : REDIRECT_OUT ID
                | REDIRECT_IN ID
                | PIPE command'''
    pass

def p_assignment(p):
    '''assignment : ID EQUALS expression'''
    # Demo assignments: "x = 42", "total = a + b * 3"
    print(f"Assignment: {p[1]} = ...")

def p_expression(p):
    '''expression : expression PLUS term
                  | expression MINUS term
                  | term'''
    # Demo expressions to try in a test line:
    # - Single term:                 "42"
    # - Simple addition/subtraction: "1 + 2", "a - b"
    # - Mixed with multiplication:   "a + b * (c - 2)"
    # These exercise the 'expression' rule (left-recursive plus/minus).
    pass

def p_term(p):
    '''term : term MULTIPLY factor
            | term DIVIDE factor
            | factor'''
    # Demo terms to try:
    # - Multiplication/division: "3 * 4", "x / y"
    # - Combined with factor:    "x * (y + 2)"
    # These exercise the 'term' rule (left-recursive multiply/divide).
    pass

def p_factor(p):
    '''factor : NUMBER
              | ID
              | LPAREN expression RPAREN'''
    # Demo factors to try:
    # - Number:    "123"
    # - Identifier:"varName"
    # - Parenthesized expression: "(1 + 2)"
    # These are the base units for 'term' and 'expression'.
    pass

def p_if_statement(p):
    '''if_statement : IF condition THEN statement_list FI
                    | IF condition THEN statement_list ELSE statement_list FI'''
    # Demo if statements (use 'condition' which is an expression in this grammar):
    # - Without else: "if x then y; fi"
    # - With else:    "if x then a; else b; fi"
    # - Using an expression condition: "if a + b then echo; fi"
    # - Multiple statements inside: "if x then a; b; fi"
    # Note: statement_list items are separated by semicolons or new statements.
    print("If statement recognized")

def p_condition(p):
    '''condition : expression'''
    # Demo conditions (this grammar treats a condition as an expression):
    # - Simple identifier: "x"
    # - Numeric literal:  "1"
    # - Expression:        "a + b" or "(a - b) * 2"
    # These examples exercise the 'condition' rule which delegates to 'expression'.
    pass

def p_for_loop(p):
    '''for_loop : FOR ID IN arg_list DO statement_list DONE'''
    print("For loop recognized")

def p_empty(p):
    '''empty :'''
    pass

def p_error(p):
    if p:
        print(f"Syntax error at token '{p.value}'")
    else:
        print("Syntax error at EOF")

parser = yacc.yacc()
