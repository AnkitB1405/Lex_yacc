from lexer import lexer
from parser import parser

while True:
    try:
        data = input('shell> ')
    except EOFError:
        break
    if not data:
        continue
    result = parser.parse(data, lexer=lexer)
    print("Parsed successfully!" if result is not None else "Parse error.")
