# main.py

from parser import parser, lexer   # parser.py already imports tokens & builds parser

if __name__ == "__main__":
    print("Enter Java statement (Ctrl+D to exit). Examples:")
    print("  int x;")
    print("  void f();")
    print("  int add() {}")

    try:
        while True:
            s = input("Input: ").strip()
            if not s:
                continue

            # Reset lexer input for each new statement
            lexer.input(s)

            # Parse the statement
            parser.parse(s, lexer=lexer)

    except EOFError:
        print("\nExiting.")