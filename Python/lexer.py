import ply.lex as lex

reserved = {
    'if': 'IF',
    'then': 'THEN',
    'else': 'ELSE',
    'fi': 'FI',
    'for': 'FOR',
    'do': 'DO',
    'done': 'DONE',
    'while': 'WHILE',
    'in': 'IN'
}

tokens = [
    'ID',
    'NUMBER',
    'EQUAL',
    'PIPE',
    'REDIRECT_IN',
    'REDIRECT_OUT',
    'SEMICOLON',
    'STRING'
] + list(reserved.values())

t_EQUAL        = r'='
t_PIPE         = r'\|'
t_REDIRECT_IN  = r'<'
t_REDIRECT_OUT = r'>'
t_SEMICOLON    = r';'
t_STRING       = r'\"([^"]*)\"|\'([^\']*)\''
t_ignore       = ' \t'

def t_ID(t):
    r'[a-zA-Z_][a-zA-Z0-9_]*'
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
    print(f'Illegal character: {t.value[0]}')
    t.lexer.skip(1)

lexer = lex.lex()
