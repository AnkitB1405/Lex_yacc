import ply.yacc as yacc
from lexer import tokens

start = 'input'

def p_input(p):
    '''input : statements
             | command
             | empty'''
    pass

def p_statements(p):
    '''statements : statement
                  | statements statement'''
    pass

def p_statement(p):
    '''statement : command
                 | if_statement
                 | loop_statement'''
    pass

def p_command(p):
    '''command : ID
               | ID argument_list
               | ID argument_list redirects
               | ID redirects'''
    pass

def p_argument_list(p):
    '''argument_list : argument_list argument
                     | argument
                     | empty'''
    pass

def p_argument(p):
    '''argument : STRING
                | NUMBER
                | ID'''
    pass

def p_redirects(p):
    '''redirects : PIPE command
                 | REDIRECT_OUT ID
                 | REDIRECT_IN ID
                 | empty'''
    pass

def p_if_statement(p):
    '''if_statement : IF condition THEN statements FI
                   | IF condition THEN statements ELSE statements FI'''
    pass

def p_condition(p):
    '''condition : command'''
    pass

def p_loop_statement(p):
    '''loop_statement : FOR ID IN argument_list DO statements DONE'''
    pass

def p_empty(p):
    'empty :'
    pass

def p_error(p):
    print("Syntax error!")

parser = yacc.yacc()
