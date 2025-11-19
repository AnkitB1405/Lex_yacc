# lexer.py
import ply.lex as lex

tokens = (
    'DATATYPE',
    'ID',
    'LPAREN',
    'RPAREN',
    'LBRACE',
    'RBRACE',
    'SEMICOLON',
)

# Single-character tokens
t_LPAREN    = r'\('
t_RPAREN    = r'\)'
t_LBRACE    = r'\{'
t_RBRACE    = r'\}'
t_SEMICOLON = r';'

# Use functions so we can add regex flags and control precedence.
# DATATYPE must be matched BEFORE ID — functions are checked before simple tokens,
# but to be safe we use an explicit regex with word-boundaries.

def t_DATATYPE(t):
    r'\b(int|float|double|boolean|char|String|void)\b'
    return t

def t_ID(t):
    r'[a-zA-Z_][a-zA-Z_0-9]*'
    # If identifier equals a datatype (shouldn't happen because DATATYPE matched first),
    # we would handle it, but DATATYPE regex above has word boundaries so it's safe.
    return t

# ignore spaces and tabs
t_ignore = ' \t'

def t_newline(t):
    r'\n+'
    t.lexer.lineno += t.value.count("\n")

def t_error(t):
    print(f"Illegal character '{t.value[0]}' at line {t.lineno}")
    t.lexer.skip(1)

lexer = lex.lex()

# small test harness (optional)
if __name__ == "__main__":
    while True:
        try:
            s = input(">> ")
        except EOFError:
            break
        if not s:
            continue
        lexer.input(s)
        for tok in lexer:
            print(tok)