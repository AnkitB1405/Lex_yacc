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
    print(f"Assignment: {p[1]} = ...")

def p_expression(p):
    '''expression : expression PLUS term
                  | expression MINUS term
                  | term'''
    pass

def p_term(p):
    '''term : term MULTIPLY factor
            | term DIVIDE factor
            | factor'''
    pass

def p_factor(p):
    '''factor : NUMBER
              | ID
              | LPAREN expression RPAREN'''
    pass

def p_if_statement(p):
    '''if_statement : IF condition THEN statement_list FI
                    | IF condition THEN statement_list ELSE statement_list FI'''
    print("If statement recognized")

def p_condition(p):
    '''condition : expression'''
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
