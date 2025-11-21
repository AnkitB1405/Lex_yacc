from lexer import lexer
from parser import parser

print("--- Mini-Python Parser (5 Constructs) ---")
print("Enter Python code. Enter 'exit' or press Ctrl+C to quit.")

while True:
    try:
        data = input('>>> ')
        if data.strip().lower() == 'exit':
            break
        if not data.strip():
            continue

        result = parser.parse(data, lexer=lexer)

    except EOFError:
        break
