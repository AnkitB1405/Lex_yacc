Bash Lex-Yacc: Shell-based Lexer & Parser
---
A pure Bash implementation of lex and yacc concepts for compiler and language processing assignments. This project demonstrates how to build a lexer (tokenizer) and parser (syntax analyzer) using only native Linux shell scripting. It simulates the architecture of traditional compiler tools (lex, yacc, PLY) with no dependencies beyond bash itself.

Features
---
Pure Bash Implementation – No external packages, compilers, or interpreters needed.

Lexical Analyzer (lexer.sh) – Identifies tokens using regular expressions.

Parser (parser.sh) – Handles grammar rules (arithmetic, a^n b^n, variable declarations).

Main Driver (main.sh) – Interactive CLI, file processing, colored output, and test suite.

Auto Setup (setup.sh) – Quickly initializes script permissions and prepares sample files.

Extensive Testing – Built-in test mode checks grammar recognition and error handling.

Educational – Clear, modular structure for learning compiler basics.

File Structure
---
text
.
├── lexer.sh

├── parser.sh
├── main.sh
├── setup.sh
├── sample_expressions.txt
├── sample_sequences.txt
├── sample_declarations.txt
└── README.md
Supported Grammars
Arithmetic Expressions:
e.g. 3 + 4 * (2 - 1)

aⁿbⁿ Sequences:
e.g. aabb, aaabbb

Variable Declarations:
e.g. int x, y;

Getting Started
---
1. Clone and Setup
bash
git clone https://github.com/yourusername/bash-lex-yacc.git
cd bash-lex-yacc
chmod +x setup.sh
./setup.sh
2. Usage
Interactive Mode:

bash
./main.sh
Test Mode:

bash
./main.sh -t
Process a File:

bash
./main.sh -f sample_expressions.txt -g expression
Help:

bash
./main.sh --help
Examples
Parsing an Expression:

bash
$ ./main.sh -g expression
>>> (1 + 2) * 4
✓ INPUT ACCEPTED
aⁿbⁿ Grammar:

bash
$ ./main.sh -g sequence
>>> aaabbb
✓ INPUT ACCEPTED
Variable Declaration:

bash
$ ./main.sh -g declaration
>>> float x, y;
✓ INPUT ACCEPTED

Screenshots
---
Add some screenshots of your terminal session showing interactive mode, test cases, and error detection.

Project Goals
---
To illustrate compiler construction principles using the Bash shell.

To provide a robust, portable, and dependency-free solution for lex/yacc assignments.

To serve as an educational resource for students and educators.
