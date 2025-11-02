import ply.yacc as yacc
from lexer import tokens

def p_statement_list(p):
    '''statements : statement
                  | statements statement'''
    pass

def p_statement(p):
    '''statement : command
                 | if_statement'''
    pass

def p_command(p):
    '''command : ID argument_list optional_redirects
               | ID optional_redirects'''
    pass

def p_argument_list(p):
    '''argument_list : argument_list argument
                     | argument'''
    pass

def p_argument(p):
    '''argument : STRING
                | NUMBER
                | ID'''
    pass

def p_optional_redirects(p):
    '''optional_redirects : PIPE command
                         | REDIRECT_OUT ID
                         | REDIRECT_IN ID
                         | SEMICOLON
                         |'''
    pass

def p_if_statement(p):
    '''if_statement : IF condition THEN statements optional_else FI'''
    pass

def p_condition(p):
    '''condition : command'''
    pass

def p_optional_else(p):
    '''optional_else : ELSE statements
                     |'''
    pass

def p_error(p):
    print("Syntax error!")

parser = yacc.yacc()
