import ply.yacc as yacc
from lexer import tokens

def p_statements(p):
    '''statements : statement
                  | statements statement'''
    pass

def p_statement(p):
    '''statement : command SEMICOLON
                 | if_statement
                 | loop_statement
                 | command'''
    pass

def p_command(p):
    '''command : ID argument_list
               | ID
               | command PIPE command
               | command REDIRECT_OUT ID
               | command REDIRECT_IN ID'''
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

def p_error(p):
    print("Syntax error!")

parser = yacc.yacc()
