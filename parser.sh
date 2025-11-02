#!/bin/bash
# parser.sh - Shell-based Parser
# Implements parsing using bash functions and pattern matching
# Based on PLY yacc concepts but written in pure bash

# Source the lexer for token functionality
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lexer.sh"

# Global parser state variables
CURRENT_TOKEN_INDEX=0
PARSE_SUCCESS=true
PARSE_TREE=()

# Grammar rule functions (similar to PLY p_ functions)
# Each function represents a grammar production rule

# Grammar: expression -> expression PLUS term | expression MINUS term | term
parse_expression() {
    echo "Parsing expression..." >&2
    
    # Parse the first term
    if ! parse_term; then
        return 1
    fi
    
    # Handle left-associative operators (+ and -)
    while true; do
        local current_token
        current_token=$(get_token_at_index $CURRENT_TOKEN_INDEX)
        
        case "$current_token" in
            "PLUS")
                echo "Found PLUS operator" >&2
                CURRENT_TOKEN_INDEX=$((CURRENT_TOKEN_INDEX + 1))
                if ! parse_term; then
                    parser_error "Expected term after PLUS"
                    return 1
                fi
                echo "Expression: PLUS operation completed" >&2
                ;;
            "MINUS")
                echo "Found MINUS operator" >&2
                CURRENT_TOKEN_INDEX=$((CURRENT_TOKEN_INDEX + 1))
                if ! parse_term; then
                    parser_error "Expected term after MINUS"
                    return 1
                fi
                echo "Expression: MINUS operation completed" >&2
                ;;
            *)
                # No more + or - operators, exit loop
                break
                ;;
        esac
    done
    
    echo "Expression parsing successful" >&2
    return 0
}

# Grammar: term -> term TIMES factor | term DIVIDE factor | factor
parse_term() {
    echo "Parsing term..." >&2
    
    # Parse the first factor
    if ! parse_factor; then
        return 1
    fi
    
    # Handle left-associative operators (* and /)
    while true; do
        local current_token
        current_token=$(get_token_at_index $CURRENT_TOKEN_INDEX)
        
        case "$current_token" in
            "TIMES")
                echo "Found TIMES operator" >&2
                CURRENT_TOKEN_INDEX=$((CURRENT_TOKEN_INDEX + 1))
                if ! parse_factor; then
                    parser_error "Expected factor after TIMES"
                    return 1
                fi
                echo "Term: TIMES operation completed" >&2
                ;;
            "DIVIDE")
                echo "Found DIVIDE operator" >&2
                CURRENT_TOKEN_INDEX=$((CURRENT_TOKEN_INDEX + 1))
                if ! parse_factor; then
                    parser_error "Expected factor after DIVIDE"
                    return 1
                fi
                echo "Term: DIVIDE operation completed" >&2
                ;;
            *)
                # No more * or / operators, exit loop
                break
                ;;
        esac
    done
    
    echo "Term parsing successful" >&2
    return 0
}

# Grammar: factor -> NUMBER | LPAREN expression RPAREN
parse_factor() {
    echo "Parsing factor..." >&2
    
    local current_token
    current_token=$(get_token_at_index $CURRENT_TOKEN_INDEX)
    
    case "$current_token" in
        "NUMBER")
            local value
            value=$(get_token_value_at_index $CURRENT_TOKEN_INDEX)
            echo "Found NUMBER: $value" >&2
            CURRENT_TOKEN_INDEX=$((CURRENT_TOKEN_INDEX + 1))
            return 0
            ;;
        "LPAREN")
            echo "Found LPAREN - parsing parenthesized expression" >&2
            CURRENT_TOKEN_INDEX=$((CURRENT_TOKEN_INDEX + 1))
            
            # Parse the expression inside parentheses
            if ! parse_expression; then
                parser_error "Expected expression after LPAREN"
                return 1
            fi
            
            # Expect closing parenthesis
            current_token=$(get_token_at_index $CURRENT_TOKEN_INDEX)
            if [[ "$current_token" != "RPAREN" ]]; then
                parser_error "Expected RPAREN, found $current_token"
                return 1
            fi
            
            echo "Found RPAREN - parenthesized expression complete" >&2
            CURRENT_TOKEN_INDEX=$((CURRENT_TOKEN_INDEX + 1))
            return 0
            ;;
        *)
            parser_error "Expected NUMBER or LPAREN, found $current_token"
            return 1
            ;;
    esac
}

# Grammar for a^n b^n language: sequence -> A sequence B | A B
parse_sequence() {
    echo "Parsing a^n b^n sequence..." >&2
    
    local current_token
    current_token=$(get_token_at_index $CURRENT_TOKEN_INDEX)
    
    # Must start with A
    if [[ "$current_token" != "A" ]]; then
        parser_error "Expected A token, found $current_token"
        return 1
    fi
    
    echo "Found A token" >&2
    CURRENT_TOKEN_INDEX=$((CURRENT_TOKEN_INDEX + 1))
    
    # Check if there's another A (recursive case: A sequence B)
    current_token=$(get_token_at_index $CURRENT_TOKEN_INDEX)
    if [[ "$current_token" == "A" ]]; then
        echo "Recursive case: A sequence B" >&2
        if ! parse_sequence; then
            return 1
        fi
    fi
    
    # Must end with B
    current_token=$(get_token_at_index $CURRENT_TOKEN_INDEX)
    if [[ "$current_token" != "B" ]]; then
        parser_error "Expected B token, found $current_token"
        return 1
    fi
    
    echo "Found B token" >&2
    CURRENT_TOKEN_INDEX=$((CURRENT_TOKEN_INDEX + 1))
    
    echo "Sequence parsing successful" >&2
    return 0
}

# Grammar for variable declarations: declaration -> TYPE varlist SEMICOLON
parse_declaration() {
    echo "Parsing variable declaration..." >&2
    
    local current_token
    current_token=$(get_token_at_index $CURRENT_TOKEN_INDEX)
    
    # Expect type specifier
    if [[ "$current_token" != "TYPE" ]]; then
        parser_error "Expected TYPE, found $current_token"
        return 1
    fi
    
    local type_value
    type_value=$(get_token_value_at_index $CURRENT_TOKEN_INDEX)
    echo "Found TYPE: $type_value" >&2
    CURRENT_TOKEN_INDEX=$((CURRENT_TOKEN_INDEX + 1))
    
    # Parse variable list
    if ! parse_varlist; then
        parser_error "Expected variable list after TYPE"
        return 1
    fi
    
    # Expect semicolon
    current_token=$(get_token_at_index $CURRENT_TOKEN_INDEX)
    if [[ "$current_token" != "SEMICOLON" ]]; then
        parser_error "Expected SEMICOLON, found $current_token"
        return 1
    fi
    
    echo "Found SEMICOLON" >&2
    CURRENT_TOKEN_INDEX=$((CURRENT_TOKEN_INDEX + 1))
    
    echo "Declaration parsing successful" >&2
    return 0
}

# Grammar: varlist -> ID | ID COMMA varlist
parse_varlist() {
    echo "Parsing variable list..." >&2
    
    local current_token
    current_token=$(get_token_at_index $CURRENT_TOKEN_INDEX)
    
    # Expect identifier
    if [[ "$current_token" != "ID" ]]; then
        parser_error "Expected ID, found $current_token"
        return 1
    fi
    
    local id_value
    id_value=$(get_token_value_at_index $CURRENT_TOKEN_INDEX)
    echo "Found ID: $id_value" >&2
    CURRENT_TOKEN_INDEX=$((CURRENT_TOKEN_INDEX + 1))
    
    # Check for comma (indicating more variables)
    current_token=$(get_token_at_index $CURRENT_TOKEN_INDEX)
    if [[ "$current_token" == "COMMA" ]]; then
        echo "Found COMMA - parsing more variables" >&2
        CURRENT_TOKEN_INDEX=$((CURRENT_TOKEN_INDEX + 1))
        
        # Recursively parse more variables
        if ! parse_varlist; then
            parser_error "Expected variable list after COMMA"
            return 1
        fi
    fi
    
    echo "Variable list parsing successful" >&2
    return 0
}

# Main parsing function - determines which grammar to use
parse_input() {
    local input="$1"
    local grammar_type="$2"
    
    echo "=== PARSING PROCESS ===" >&2
    echo "Input: '$input'" >&2
    echo "Grammar: $grammar_type" >&2
    
    # First, tokenize the input
    if ! tokenize_input "$input"; then
        echo "Tokenization failed" >&2
        return 1
    fi
    
    # Reset parser state
    CURRENT_TOKEN_INDEX=0
    PARSE_SUCCESS=true
    
    # Choose appropriate grammar based on type
    case "$grammar_type" in
        "expression" | "arithmetic")
            echo "Using arithmetic expression grammar" >&2
            if parse_expression; then
                echo "=== PARSING SUCCESSFUL ===" >&2
                return 0
            else
                echo "=== PARSING FAILED ===" >&2
                return 1
            fi
            ;;
        "sequence" | "anbn")
            echo "Using a^n b^n sequence grammar" >&2
            if parse_sequence; then
                echo "=== PARSING SUCCESSFUL ===" >&2
                return 0
            else
                echo "=== PARSING FAILED ===" >&2
                return 1
            fi
            ;;
        "declaration" | "variable")
            echo "Using variable declaration grammar" >&2
            if parse_declaration; then
                echo "=== PARSING SUCCESSFUL ===" >&2
                return 0
            else
                echo "=== PARSING FAILED ===" >&2
                return 1
            fi
            ;;
        *)
            echo "Unknown grammar type: $grammar_type" >&2
            echo "Available types: expression, sequence, declaration" >&2
            return 1
            ;;
    esac
}

# Error handling function
parser_error() {
    local message="$1"
    echo "Parse error at token index $CURRENT_TOKEN_INDEX: $message" >&2
    
    local current_token
    current_token=$(get_token_at_index $CURRENT_TOKEN_INDEX)
    local current_value
    current_value=$(get_token_value_at_index $CURRENT_TOKEN_INDEX)
    
    echo "Current token: $current_token = '$current_value'" >&2
    PARSE_SUCCESS=false
    return 1
}

# Function to check if parsing completed successfully
parsing_complete() {
    local total_tokens
    total_tokens=$(get_token_count)
    
    if [[ $CURRENT_TOKEN_INDEX -lt $total_tokens ]]; then
        local remaining_token
        remaining_token=$(get_token_at_index $CURRENT_TOKEN_INDEX)
        parser_error "Unexpected token: $remaining_token"
        return 1
    fi
    
    return 0
}

# Export functions for use by other scripts
export -f parse_input
export -f parse_expression
export -f parse_sequence  
export -f parse_declaration

# If script is run directly, demonstrate parser functionality
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "=== BASH PARSER DEMONSTRATION ==="
    
    # Test case 1: Arithmetic expression
    echo "Test 1: Arithmetic Expression"
    parse_input "3 + 4 * 2" "expression"
    echo
    
    # Test case 2: Parenthesized expression  
    echo "Test 2: Parenthesized Expression"
    parse_input "(1 + 2) * 3" "expression"
    echo
    
    # Test case 3: a^n b^n sequence
    echo "Test 3: a^n b^n Sequence"
    parse_input "aaabbb" "sequence"
    echo
    
    # Test case 4: Variable declaration
    echo "Test 4: Variable Declaration"
    parse_input "int x, y, z;" "declaration"
    echo
    
    # Test case 5: Error case
    echo "Test 5: Error Case"
    parse_input "3 + * 4" "expression"
    echo
fi