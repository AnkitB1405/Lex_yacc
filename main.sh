#!/bin/bash
# main.sh - Main program for shell-based lexer/parser
# Integrates lexer and parser functionality with user interface
# Based on PLY main concepts but written in pure bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the lexer and parser modules
source "$SCRIPT_DIR/lexer.sh"
source "$SCRIPT_DIR/parser.sh"

# Program metadata
PROGRAM_NAME="Bash Lex-Yacc Implementation"
VERSION="1.0"
AUTHOR="Shell Programming Project"

# Color codes for output formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display program header
show_header() {
    echo -e "${BLUE}=================================${NC}"
    echo -e "${BLUE}$PROGRAM_NAME${NC}"
    echo -e "${BLUE}Version: $VERSION${NC}"
    echo -e "${BLUE}=================================${NC}"
    echo
}

# Function to display help information
show_help() {
    echo -e "${YELLOW}Usage:${NC} $0 [OPTIONS]"
    echo
    echo -e "${YELLOW}Options:${NC}"
    echo "  -h, --help              Show this help message"
    echo "  -v, --version           Show version information" 
    echo "  -i, --interactive       Run in interactive mode (default)"
    echo "  -f, --file FILE         Parse input from file"
    echo "  -g, --grammar TYPE      Specify grammar type (expression|sequence|declaration)"
    echo "  -t, --test              Run built-in test cases"
    echo "  -q, --quiet             Suppress debug output"
    echo
    echo -e "${YELLOW}Grammar Types:${NC}"
    echo "  expression, arithmetic  - Parse arithmetic expressions (3 + 4 * 2)"
    echo "  sequence, anbn          - Parse a^n b^n sequences (aaabbb)"
    echo "  declaration, variable   - Parse variable declarations (int x, y;)"
    echo
    echo -e "${YELLOW}Examples:${NC}"
    echo "  $0                      # Interactive mode"
    echo "  $0 -g expression        # Interactive with expression grammar"
    echo "  $0 -f input.txt -g sequence  # Parse file with sequence grammar"
    echo "  $0 -t                   # Run test cases"
}

# Function to display version information
show_version() {
    echo "$PROGRAM_NAME version $VERSION"
    echo "Bash implementation of lexical analysis and parsing"
}

# Function to get grammar type from user
get_grammar_type() {
    echo -e "${YELLOW}Available Grammar Types:${NC}"
    echo "1. expression  - Arithmetic expressions (e.g., 3 + 4 * 2)"
    echo "2. sequence    - a^n b^n sequences (e.g., aaabbb)" 
    echo "3. declaration - Variable declarations (e.g., int x, y;)"
    echo
    
    while true; do
        read -p "Select grammar type (1-3) or enter name: " choice
        
        case "$choice" in
            1|expression|arithmetic)
                echo "expression"
                return 0
                ;;
            2|sequence|anbn)
                echo "sequence" 
                return 0
                ;;
            3|declaration|variable)
                echo "declaration"
                return 0
                ;;
            *)
                echo -e "${RED}Invalid choice. Please select 1-3 or enter a valid grammar name.${NC}"
                ;;
        esac
    done
}

# Function to process a single input
process_input() {
    local input="$1"
    local grammar_type="$2"
    local quiet_mode="$3"
    
    if [[ "$quiet_mode" != "true" ]]; then
        echo -e "${BLUE}Processing input: '$input'${NC}"
        echo -e "${BLUE}Grammar type: $grammar_type${NC}"
        echo
    fi
    
    # Redirect stderr to /dev/null in quiet mode
    if [[ "$quiet_mode" == "true" ]]; then
        if parse_input "$input" "$grammar_type" 2>/dev/null; then
            echo -e "${GREEN}✓ ACCEPTED${NC}"
            return 0
        else
            echo -e "${RED}✗ REJECTED${NC}"
            return 1
        fi
    else
        if parse_input "$input" "$grammar_type"; then
            echo -e "${GREEN}✓ INPUT ACCEPTED${NC}"
            return 0
        else
            echo -e "${RED}✗ INPUT REJECTED${NC}"
            return 1
        fi
    fi
}

# Function to run interactive mode
run_interactive() {
    local grammar_type="$1"
    local quiet_mode="$2"
    
    show_header
    
    # Get grammar type if not specified
    if [[ -z "$grammar_type" ]]; then
        grammar_type=$(get_grammar_type)
    fi
    
    echo -e "${GREEN}Interactive Mode - Using '$grammar_type' grammar${NC}"
    echo "Enter input to parse (or 'quit' to exit, 'help' for help, 'change' to change grammar):"
    echo
    
    while true; do
        read -p ">>> " input
        
        case "$input" in
            quit|exit|q)
                echo -e "${BLUE}Goodbye!${NC}"
                break
                ;;
            help|h)
                echo
                echo -e "${YELLOW}Interactive Commands:${NC}"
                echo "  quit, exit, q    - Exit the program"
                echo "  help, h          - Show this help"
                echo "  change, c        - Change grammar type"
                echo "  test             - Run quick tests"
                echo "  clear            - Clear screen"
                echo "  Any other input  - Parse with current grammar"
                echo
                ;;
            change|c)
                grammar_type=$(get_grammar_type)
                echo -e "${GREEN}Changed to '$grammar_type' grammar${NC}"
                echo
                ;;
            test)
                run_quick_tests "$grammar_type" "$quiet_mode"
                ;;
            clear)
                clear
                show_header
                echo -e "${GREEN}Interactive Mode - Using '$grammar_type' grammar${NC}"
                ;;
            "")
                # Empty input, do nothing
                ;;
            *)
                echo
                process_input "$input" "$grammar_type" "$quiet_mode"
                echo
                ;;
        esac
    done
}

# Function to run test cases
run_test_cases() {
    local quiet_mode="$1"
    
    echo -e "${BLUE}Running comprehensive test cases...${NC}"
    echo
    
    local total_tests=0
    local passed_tests=0
    
    # Test cases for arithmetic expressions
    echo -e "${YELLOW}Testing Arithmetic Expressions:${NC}"
    declare -a expression_tests=(
        "3 + 4"
        "2 * 3 + 1"
        "(1 + 2) * 3"
        "10 / 2 - 1"
        "1.5 + 2.7"
    )
    
    for test_input in "${expression_tests[@]}"; do
        ((total_tests++))
        echo -n "Test: '$test_input' ... "
        if process_input "$test_input" "expression" true; then
            ((passed_tests++))
        fi
    done
    echo
    
    # Test cases for a^n b^n sequences
    echo -e "${YELLOW}Testing a^n b^n Sequences:${NC}"
    declare -a sequence_tests=(
        "ab"
        "aabb"  
        "aaabbb"
        "aaaabbbb"
    )
    
    for test_input in "${sequence_tests[@]}"; do
        ((total_tests++))
        echo -n "Test: '$test_input' ... "
        if process_input "$test_input" "sequence" true; then
            ((passed_tests++))
        fi
    done
    echo
    
    # Test cases for variable declarations
    echo -e "${YELLOW}Testing Variable Declarations:${NC}"
    declare -a declaration_tests=(
        "int x;"
        "float y, z;"
        "char a, b, c;"
        "double value;"
    )
    
    for test_input in "${declaration_tests[@]}"; do
        ((total_tests++))
        echo -n "Test: '$test_input' ... "
        if process_input "$test_input" "declaration" true; then
            ((passed_tests++))
        fi
    done
    echo
    
    # Error test cases (should fail)
    echo -e "${YELLOW}Testing Error Cases (should fail):${NC}"
    declare -a error_tests=(
        "3 + + 4"
        "aabbb"
        "int ;"
        "( 2 + 3"
    )
    
    for test_input in "${error_tests[@]}"; do
        ((total_tests++))
        echo -n "Error test: '$test_input' ... "
        if ! process_input "$test_input" "expression" true; then
            echo -e "${GREEN}✓ CORRECTLY REJECTED${NC}"
            ((passed_tests++))
        else
            echo -e "${RED}✗ INCORRECTLY ACCEPTED${NC}"
        fi
    done
    echo
    
    # Display results
    echo -e "${BLUE}Test Results:${NC}"
    echo -e "${GREEN}Passed: $passed_tests/$total_tests${NC}"
    
    if [[ $passed_tests -eq $total_tests ]]; then
        echo -e "${GREEN}All tests passed! ✓${NC}"
        return 0
    else
        echo -e "${RED}Some tests failed. ✗${NC}"
        return 1
    fi
}

# Function to run quick tests for current grammar
run_quick_tests() {
    local grammar_type="$1"
    local quiet_mode="$2"
    
    echo -e "${BLUE}Running quick tests for '$grammar_type' grammar...${NC}"
    echo
    
    case "$grammar_type" in
        expression)
            process_input "2 + 3 * 4" "$grammar_type" "$quiet_mode"
            echo
            process_input "(1 + 2) * (3 + 4)" "$grammar_type" "$quiet_mode"
            ;;
        sequence)
            process_input "aabb" "$grammar_type" "$quiet_mode"
            echo
            process_input "aaabbb" "$grammar_type" "$quiet_mode"
            ;;
        declaration)
            process_input "int x, y;" "$grammar_type" "$quiet_mode"
            echo
            process_input "float value;" "$grammar_type" "$quiet_mode"
            ;;
    esac
    echo
}

# Function to process file input
process_file() {
    local filename="$1"
    local grammar_type="$2"
    local quiet_mode="$3"
    
    if [[ ! -f "$filename" ]]; then
        echo -e "${RED}Error: File '$filename' not found.${NC}"
        return 1
    fi
    
    echo -e "${BLUE}Processing file: $filename${NC}"
    echo -e "${BLUE}Grammar type: $grammar_type${NC}"
    echo
    
    local line_number=1
    local total_lines=0
    local accepted_lines=0
    
    while IFS= read -r line; do
        # Skip empty lines and comments
        if [[ -n "$line" && ! "$line" =~ ^[[:space:]]*# ]]; then
            ((total_lines++))
            echo -n "Line $line_number: "
            if process_input "$line" "$grammar_type" true; then
                ((accepted_lines++))
            fi
        fi
        ((line_number++))
    done < "$filename"
    
    echo
    echo -e "${BLUE}File processing complete:${NC}"
    echo -e "${GREEN}Accepted: $accepted_lines/$total_lines lines${NC}"
    
    return 0
}

# Main function
main() {
    local interactive_mode=true
    local grammar_type=""
    local filename=""
    local run_tests=false
    local quiet_mode=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                show_version
                exit 0
                ;;
            -i|--interactive)
                interactive_mode=true
                shift
                ;;
            -f|--file)
                filename="$2"
                interactive_mode=false
                shift 2
                ;;
            -g|--grammar)
                grammar_type="$2"
                shift 2
                ;;
            -t|--test)
                run_tests=true
                interactive_mode=false
                shift
                ;;
            -q|--quiet)
                quiet_mode=true
                shift
                ;;
            *)
                echo -e "${RED}Unknown option: $1${NC}"
                echo "Use -h or --help for usage information."
                exit 1
                ;;
        esac
    done
    
    # Validate grammar type if specified
    if [[ -n "$grammar_type" ]]; then
        case "$grammar_type" in
            expression|arithmetic|sequence|anbn|declaration|variable)
                # Valid grammar type
                ;;
            *)
                echo -e "${RED}Invalid grammar type: $grammar_type${NC}"
                echo "Valid types: expression, sequence, declaration"
                exit 1
                ;;
        esac
    fi
    
    # Run appropriate mode
    if [[ "$run_tests" == true ]]; then
        run_test_cases "$quiet_mode"
    elif [[ -n "$filename" ]]; then
        if [[ -z "$grammar_type" ]]; then
            echo -e "${RED}Error: Grammar type required when processing files.${NC}"
            echo "Use -g option to specify grammar type."
            exit 1
        fi
        process_file "$filename" "$grammar_type" "$quiet_mode"
    elif [[ "$interactive_mode" == true ]]; then
        run_interactive "$grammar_type" "$quiet_mode"
    fi
}

# Check if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi