import ply.lex as lex

# Token list
tokens = [
    'IF', 'THEN', 'ELSE', 'FI', 'FOR', 'DO', 'DONE', 'WHILE', 'IN',
    'ID', 'NUMBER', 
    'PIPE', 'REDIRECT_IN', 'REDIRECT_OUT', 'APPEND',
    'SEMICOLON',
    'STRING',
    'EQUALS',
    'LPAREN', 'RPAREN',
    'PLUS', 'MINUS', 'MULTIPLY', 'DIVIDE',
]

# Reserved words
reserved = {
    'if': 'IF',
    'then': 'THEN',
    'else': 'ELSE',
    'fi': 'FI',
    'for': 'FOR',
    'do': 'DO',
    'done': 'DONE',
    'while': 'WHILE',
    'in': 'IN',
}

# Token rules
t_PIPE         = r'\|'
t_REDIRECT_OUT = r'>>'
t_REDIRECT_IN  = r'<'
t_APPEND       = r'>>'
t_EQUALS       = r'='
t_SEMICOLON    = r';'
t_LPAREN       = r'\('
t_RPAREN       = r'\)'
t_PLUS         = r'\+'
t_MINUS        = r'-'
t_MULTIPLY     = r'\*'
t_DIVIDE       = r'/'

def t_STRING(t):
    r'\"[^"]*\"|\'[^\']*\''
    t.value = t.value[1:-1]  # Remove quotes
    return t

def t_ID(t):
    r'[a-zA-Z_][a-zA-Z0-9_]*'
    t.type = reserved.get(t.value, 'ID')
    return t

def t_NUMBER(t):
    r'\d+'
    t.value = int(t.value)
    return t

# Ignore spaces and tabs
t_ignore = ' \t'

def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

def t_error(t):
    print(f"Illegal character: '{t.value[0]}'")
    t.lexer.skip(1)

lexer = lex.lex()
