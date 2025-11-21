import ply.yacc as yacc
from lexer import tokens

def p_program(p):
    '''program : statements'''
    print("--- PARSE SUCCESSFUL ---")

def p_statements(p):
    '''statements : statement
                  | statements statement'''
    pass

def p_statement(p):
    '''statement : assignment_statement
                 | expression_statement
                 | if_statement
                 | while_statement
                 | function_definition'''
    pass

def p_assignment_statement(p):
    '''assignment_statement : ID EQUALS expression'''
    print(f"Valid Assignment: {p[1]} = ...")

def p_expression_statement(p):
    '''expression_statement : expression'''
    print("Valid Expression")

def p_expression_binop(p):
    '''expression : expression PLUS term
                  | expression MINUS term'''
    pass

def p_expression_term(p):
    '''expression : term'''
    pass

def p_term_binop(p):
    '''term : term TIMES factor
            | term DIVIDE factor'''
    pass

def p_term_factor(p):
    '''term : factor'''
    pass

def p_factor(p):
    '''factor : NUMBER
              | ID'''
    pass

def p_factor_group(p):
    '''factor : LPAREN expression RPAREN'''
    pass

def p_if_statement(p):
    '''if_statement : IF expression COLON statement'''
    print("Valid IF statement")

def p_while_statement(p):
    '''while_statement : WHILE expression COLON statement'''
    print("Valid WHILE statement")

def p_function_definition(p):
    '''function_definition : DEF ID LPAREN arg_list RPAREN COLON statement'''
    print(f"Valid Function Definition: def {p[2]}(...):")

def p_arg_list(p):
    '''arg_list :
                | parameters'''
    pass

def p_parameters(p):
    '''parameters : ID
                  | parameters COMMA ID'''
    pass

def p_error(p):
    if p:
        print(f"Syntax error at token {p.type} ('{p.value}')")
    else:
        print("Syntax error at end of input")

parser = yacc.yacc()
