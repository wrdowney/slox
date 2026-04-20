public enum TokenType: Equatable, Hashable {
    // single-character tokens
    case LEFT_PAREN, RIGHT_PAREN
    case LEFT_BRACE, RIGHT_BRACE
    case COMMA
    case DOT
    case MINUS
    case PLUS
    case SEMICOLON
    case SLASH
    case STAR

    // one or two-character tokens
    case BANG, BANG_EQUAL
    case EQUAL, EQUAL_EQUAL
    case GREATER, GREATER_EQUAL
    case LESS, LESS_EQUAL

    // Literals
    case IDENTIFIER, STRING, NUMBER

    // Keywords
    case AND, CLASS, ELSE, FALSE, FUN, FOR, IF, NIL
    case OR, PRINT, RETURN, SUPER, THIS, TRUE, VAR, WHILE

    case EOF
}
