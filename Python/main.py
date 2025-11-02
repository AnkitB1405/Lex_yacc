from lexer import lexer
from parser import parser

def main():
    print("Shell parser (type Ctrl+D or Ctrl+C to exit)")
    try:
        while True:
            data = input('shell> ')
            if not data.strip():
                continue
            result = parser.parse(data, lexer=lexer)
            print("Parsed successfully!" if result is not None else "Parse error.")
    except (EOFError, KeyboardInterrupt):
        print("\nExiting.")

if __name__ == "__main__":
    main()
