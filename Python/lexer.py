import ply.lex as lex

tokens = [
    'ID', 'NUMBER', 'EQUAL', 'PIPE', 'REDIRECT_OUT', 'REDIRECT_IN', 'SEMICOLON', 'STRING',
]

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

t_EQUAL        = r'='
t_PIPE         = r'\|'
t_REDIRECT_IN  = r'<'
t_REDIRECT_OUT = r'>'
t_SEMICOLON    = r';'
t_STRING       = r'\"([^"]*)\"|\'([^\']*)\''
t_ignore       = ' \t'

def t_ID(t):
    r'[a-zA-Z_\./][a-zA-Z0-9_\./\-]*'
    t.type = reserved.get(t.value, 'ID')
    return t

def t_NUMBER(t):
    r'\d+'
    t.value = int(t.value)
    return t

def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

def t_error(t):
    print(f"Illegal character: {t.value[0]}")
    t.lexer.skip(1)

lexer = lex.lex()
