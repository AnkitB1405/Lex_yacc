#!/bin/bash
# lexer.sh - Shell-based Lexical Analyzer
# Implements tokenization using bash regular expressions and pattern matching
# Based on PLY concepts but written in pure bash

# Global variables for token processing
declare -a TOKENS=()
declare -a TOKEN_VALUES=()
INPUT_TEXT=""
TOKEN_INDEX=0

# Define token types (equivalent to PLY tokens list)
TOKEN_TYPES=(
    "NUMBER"
    "PLUS" 
    "MINUS"
    "TIMES"
    "DIVIDE"
    "LPAREN"
    "RPAREN"
    "ID"
    "EQUALS"
    "SEMICOLON"
    "COMMA"
    "TYPE"
    "NEWLINE"
    "A"
    "B"
)

# Regular expression patterns for each token type
declare -A TOKEN_PATTERNS=(
    ["NUMBER"]="^[0-9]+(\.[0-9]+)?"
    ["PLUS"]="^\+"
    ["MINUS"]="^-"
    ["TIMES"]="^\*"
    ["DIVIDE"]="^/"
    ["LPAREN"]="^\("
    ["RPAREN"]="^\)"
    ["EQUALS"]="^="
    ["SEMICOLON"]="^;"
    ["COMMA"]="^,"
    ["NEWLINE"]="^[\n\r]+"
    ["A"]="^a+"
    ["B"]="^b+"
    ["ID"]="^[a-zA-Z][a-zA-Z0-9]*"
    ["TYPE"]="^(int|char|float|double)"
)

# Reserved words (similar to PLY reserved dictionary)
declare -A RESERVED_WORDS=(
    ["int"]="TYPE"
    ["char"]="TYPE" 
    ["float"]="TYPE"
    ["double"]="TYPE"
)

# Function to initialize lexer with input text
initialize_lexer() {
    local input="$1"
    INPUT_TEXT="$input"
    TOKENS=()
    TOKEN_VALUES=()
    TOKEN_INDEX=0
    echo "Lexer initialized with input: '$input'" >&2
}

# Function to skip whitespace
skip_whitespace() {
    while [[ ${INPUT_TEXT:0:1} =~ [[:space:]] && ${INPUT_TEXT:0:1} != $'\n' ]]; do
        INPUT_TEXT="${INPUT_TEXT:1}"
    done
}

# Function to match a token pattern
match_token() {
    local token_type="$1"
    local pattern="${TOKEN_PATTERNS[$token_type]}"
    
    if [[ -z "$pattern" ]]; then
        return 1
    fi
    
    # Use bash regex matching
    if [[ "$INPUT_TEXT" =~ $pattern ]]; then
        local match="${BASH_REMATCH[0]}"
        
        # Special handling for ID tokens (check if reserved word)
        if [[ "$token_type" == "ID" && -n "${RESERVED_WORDS[$match]}" ]]; then
            token_type="${RESERVED_WORDS[$match]}"
        fi
        
        # Add token to arrays
        TOKENS+=("$token_type")
        TOKEN_VALUES+=("$match")
        
        # Remove matched text from input
        INPUT_TEXT="${INPUT_TEXT:${#match}}"
        
        echo "Matched token: $token_type = '$match'" >&2
        return 0
    fi
    
    return 1
}

# Function to get next token
get_next_token() {
    # Skip whitespace first
    skip_whitespace
    
    # Check if we've reached end of input
    if [[ -z "$INPUT_TEXT" ]]; then
        echo "EOF"
        return 1
    fi
    
    # Try to match each token type
    for token_type in "${TOKEN_TYPES[@]}"; do
        if match_token "$token_type"; then
            echo "$token_type"
            return 0
        fi
    done
    
    # If no token matched, it's an error
    echo "ERROR: Illegal character '${INPUT_TEXT:0:1}'" >&2
    INPUT_TEXT="${INPUT_TEXT:1}"  # Skip the illegal character
    echo "ERROR"
    return 1
}

# Function to tokenize entire input
tokenize_input() {
    local input="$1"
    initialize_lexer "$input"
    
    echo "=== TOKENIZATION PROCESS ===" >&2
    
    while [[ -n "$INPUT_TEXT" ]]; do
        local token
        token=$(get_next_token)
        
        if [[ "$token" == "EOF" ]]; then
            break
        elif [[ "$token" == "ERROR" ]]; then
            echo "Tokenization failed due to illegal character" >&2
            return 1
        fi
    done
    
    echo "=== TOKENIZATION COMPLETE ===" >&2
    echo "Tokens found: ${#TOKENS[@]}" >&2
    
    # Print all tokens
    for ((i=0; i<${#TOKENS[@]}; i++)); do
        echo "Token[$i]: ${TOKENS[i]} = '${TOKEN_VALUES[i]}'"
    done
    
    return 0
}

# Function to get token at specific index (for parser)
get_token_at_index() {
    local index="$1"
    if [[ $index -lt ${#TOKENS[@]} ]]; then
        echo "${TOKENS[index]}"
        return 0
    else
        echo "EOF"
        return 1
    fi
}

# Function to get token value at specific index
get_token_value_at_index() {
    local index="$1"
    if [[ $index -lt ${#TOKEN_VALUES[@]} ]]; then
        echo "${TOKEN_VALUES[index]}"
        return 0
    else
        echo ""
        return 1
    fi
}

# Function to get current token count
get_token_count() {
    echo "${#TOKENS[@]}"
}

# Error handling function
lexer_error() {
    local char="$1"
    echo "Lexical error: Illegal character '$char'" >&2
    return 1
}

# Export functions for use by other scripts
export -f initialize_lexer
export -f get_next_token
export -f tokenize_input
export -f get_token_at_index
export -f get_token_value_at_index
export -f get_token_count

# If script is run directly, demonstrate lexer functionality
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "=== BASH LEXER DEMONSTRATION ==="
    
    # Test case 1: Simple arithmetic expression
    echo "Test 1: Arithmetic Expression"
    tokenize_input "3 + 4 * (2 - 1)"
    echo
    
    # Test case 2: Variable declaration (C-style)
    echo "Test 2: Variable Declaration"
    tokenize_input "int x = 5;"
    echo
    
    # Test case 3: a^n b^n language
    echo "Test 3: a^n b^n Language"
    tokenize_input "aaabbb"
    echo
    
    # Test case 4: Error case
    echo "Test 4: Error Case"
    tokenize_input "abc & 123"
    echo
fi