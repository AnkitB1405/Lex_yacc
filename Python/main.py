from lexer import lexer
from parser import parser

print("Shell Parser (type Ctrl+D or Ctrl+C to exit)")
print("=" * 50)

while True:
    try:
        data = input('shell> ')
    except (EOFError, KeyboardInterrupt):
        print("\nExiting.")
        break
    
    if not data:
        continue
    
    try:
        result = parser.parse(data, lexer=lexer)
    except Exception as e:
        print(f"Error: {e}")
