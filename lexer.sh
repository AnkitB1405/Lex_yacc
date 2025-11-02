#!/bin/bash
# lexer.sh - Shell-based Lexical Analyzer
# Implements tokenization using bash regular expressions and pattern matching

# Global variables for token processing
declare -a TOKENS=()
declare -a TOKEN_VALUES=()
INPUT_TEXT=""
TOKEN_INDEX=0

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

declare -A RESERVED_WORDS=(
    ["int"]="TYPE"
    ["char"]="TYPE" 
    ["float"]="TYPE"
    ["double"]="TYPE"
)

initialize_lexer() {
    local input="$1"
    INPUT_TEXT="$input"
    TOKENS=()
    TOKEN_VALUES=()
    TOKEN_INDEX=0
    echo "Lexer initialized with input: '$input'" >&2
}

skip_whitespace() {
    while [[ ${INPUT_TEXT:0:1} =~ [[:space:]] && ${INPUT_TEXT:0:1} != $'\n' ]]; do
        INPUT_TEXT="${INPUT_TEXT:1}"
    done
}

match_token() {
    local token_type="$1"
    local pattern="${TOKEN_PATTERNS[$token_type]}"
    
    if [[ -z "$pattern" ]]; then
        return 1
    fi
    
    if [[ "$INPUT_TEXT" =~ $pattern ]]; then
        local match="${BASH_REMATCH[0]}"
        )
        if [[ "$token_type" == "ID" && -n "${RESERVED_WORDS[$match]}" ]]; then
            token_type="${RESERVED_WORDS[$match]}"
        fi
        
        TOKENS+=("$token_type")
        TOKEN_VALUES+=("$match")
        
        INPUT_TEXT="${INPUT_TEXT:${#match}}"
        
        echo "Matched token: $token_type = '$match'" >&2
        return 0
    fi
    
    return 1
}

get_next_token() {
    skip_whitespace
    
    if [[ -z "$INPUT_TEXT" ]]; then
        echo "EOF"
        return 1
    fi
    
    for token_type in "${TOKEN_TYPES[@]}"; do
        if match_token "$token_type"; then
            echo "$token_type"
            return 0
        fi
    done
    
    # If no token matched, it's an error
    echo "ERROR: Illegal character '${INPUT_TEXT:0:1}'" >&2
    INPUT_TEXT="${INPUT_TEXT:1}"  
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

get_token_count() {
    echo "${#TOKENS[@]}"
}

lexer_error() {
    local char="$1"
    echo "Lexical error: Illegal character '$char'" >&2
    return 1
}

export -f initialize_lexer
export -f get_next_token
export -f tokenize_input
export -f get_token_at_index
export -f get_token_value_at_index
export -f get_token_count

# If script is run directly, demonstrate lexer functionality
#if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
#    echo "=== BASH LEXER DEMONSTRATION ==="
#    
#    # Test case 1: Simple arithmetic expression
#    echo "Test 1: Arithmetic Expression"
#    tokenize_input "3 + 4 * (2 - 1)"
#    echo
#    
#    # Test case 2: Variable declaration (C-style)
#    echo "Test 2: Variable Declaration"
#    tokenize_input "int x = 5;"
#    echo
#    
#    # Test case 3: a^n b^n language
#    echo "Test 3: a^n b^n Language"
#    tokenize_input "aaabbb"
#    echo
#    
#    # Test case 4: Error case
#    echo "Test 4: Error Case"
#    tokenize_input "abc & 123"
#    echo
#fi