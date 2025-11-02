#!/bin/bash
# setup.sh - Setup script for the Bash Lex-Yacc Implementation
# Makes scripts executable and provides usage instructions

echo "======================================"
echo "Bash Lex-Yacc Implementation Setup"
echo "======================================"
echo

# Get the current directory
CURRENT_DIR="$(pwd)"

echo "Setting up in directory: $CURRENT_DIR"
echo

# Make scripts executable
echo "Making scripts executable..."
chmod +x lexer.sh
chmod +x parser.sh  
chmod +x main.sh
chmod +x setup.sh

echo "✓ Scripts are now executable"
echo

# Test if scripts exist
echo "Checking script files..."
for script in lexer.sh parser.sh main.sh; do
    if [[ -f "$script" ]]; then
        echo "✓ $script found"
    else
        echo "✗ $script missing"
        exit 1
    fi
done
echo

# Test basic functionality
echo "Testing basic functionality..."
echo

echo "1. Testing lexer directly:"
./lexer.sh >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo "✓ Lexer test passed"
else
    echo "✗ Lexer test failed"
fi

echo "2. Testing parser directly:"
./parser.sh >/dev/null 2>&1  
if [[ $? -eq 0 ]]; then
    echo "✓ Parser test passed"
else
    echo "✗ Parser test failed"
fi

echo "3. Testing main program:"
echo "quit" | ./main.sh >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo "✓ Main program test passed"
else
    echo "✗ Main program test failed"
fi

echo
echo "======================================"
echo "Setup Complete!"
echo "======================================"
echo

echo "Usage Examples:"
echo
echo "1. Interactive Mode:"
echo "   ./main.sh"
echo
echo "2. Run Test Cases:"
echo "   ./main.sh -t"
echo
echo "3. Parse Arithmetic Expression:"
echo "   echo '3 + 4 * 2' | ./main.sh -g expression -q"
echo
echo "4. Parse a^n b^n Sequence:"
echo "   echo 'aaabbb' | ./main.sh -g sequence -q"
echo
echo "5. Parse Variable Declaration:"
echo "   echo 'int x, y, z;' | ./main.sh -g declaration -q"
echo
echo "6. Help Information:"
echo "   ./main.sh --help"
echo

# Create sample input files
echo "Creating sample input files..."

cat > sample_expressions.txt << 'EOF'
# Sample arithmetic expressions
3 + 4
2 * 5 - 1
(1 + 2) * 3
10 / 2
1.5 + 2.7 * 3
EOF

cat > sample_sequences.txt << 'EOF'
# Sample a^n b^n sequences  
ab
aabb
aaabbb
aaaabbbb
aaaaabbbbb
EOF

cat > sample_declarations.txt << 'EOF'
# Sample variable declarations
int x;
float y, z;
char a, b, c;
double value;
int count, sum, average;
EOF

echo "✓ Created sample input files:"
echo "  - sample_expressions.txt"
echo "  - sample_sequences.txt" 
echo "  - sample_declarations.txt"
echo

echo "Test with sample files:"
echo "   ./main.sh -f sample_expressions.txt -g expression"
echo "   ./main.sh -f sample_sequences.txt -g sequence"
echo "   ./main.sh -f sample_declarations.txt -g declaration"
echo

echo "Project is ready to use!"
echo
echo "For detailed help, run: ./main.sh --help"