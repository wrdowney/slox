final class Scanner {
    private var source: String
    private var tokens: [Token] = []
    private var start: Int = 0
    private var current: Int = 0
    private var line: Int = 1
    private var lox: Lox
    
    init(lox: Lox, source: String) {
        self.source = source
        self.lox = lox
    }
    
    func scanTokens() -> [Token] {
        while !isAtEnd {
            start = current
            scanToken()
        }
        
        tokens.append(Token(type: .EOF, lexeme: "", literal: .none, line: line))
        return tokens
    }
    
    func scanToken() {
        let c: Character = advance()
        
        switch c {
        case "(": addToken(.LEFT_PAREN)
        case ")": addToken(.RIGHT_PAREN)
        case "{": addToken(.LEFT_BRACE)
        case "}": addToken(.RIGHT_BRACE)
        case ",": addToken(.COMMA)
        case ".": addToken(.DOT)
        case "-": addToken(.MINUS)
        case "+": addToken(.PLUS)
        case ";": addToken(.SEMICOLON)
        case "*": addToken(.STAR)
        case "!": addToken(match("=") ? .BANG_EQUAL : .BANG)
        case "=": addToken(match("=") ? .EQUAL_EQUAL : .EQUAL)
        case "<": addToken(match("=") ? .LESS_EQUAL : .LESS)
        case ">": addToken(match("=") ? .GREATER_EQUAL : .GREATER)
        case "/":
            // Check for comments
            guard !match("/") else {
                addToken(.SLASH)
                break
            }
            // Ignore the rest of the line if it is a comment
            while peek != "\n" && !isAtEnd {
                _ = advance()
            }
        case " ", "\r", "\t": break
        case "\n": line += 1
        case "\"": string()
        default:
            if c.isNumber {
                number() // Handle digits in `default` instead of switching on every digit
            } else if c.isLetter {
                identifier() // assume any lexeme starting with letter or _ is an identifier
            } else {
                // throw error for unknown lexemes
                lox.error(line: line, message: "Unexpected character.")
                break
            }
            
            
            
        }
    }
    
    private func advance() -> Character {
        if isAtEnd {
            return "\0" // unicode NUL character
        }
        let char = currentCharacter
        current += 1
        return char
    }
    
    private func addToken(_ type: TokenType) {
        addToken(type: type, literal: .none)
    }
    
    private func addToken(type: TokenType, literal: LiteralType) {
        let text: String = String(source[startIndex..<currentIndex])
        tokens.append(Token(type: type, lexeme: text, literal: literal, line: line))
    }
    
    private var isAtEnd: Bool {
        return current >= source.count
    }
    
    private var currentCharacter: Character {
        source[source.index(source.startIndex, offsetBy: current)]
    }
   
    
    /// Similar to `advance()` but only advances when character is matched.
    private func match(_ expected: Character) -> Bool {
        guard !isAtEnd, currentCharacter == expected else { return false }
        
        current += 1
        return true
    }
    
    private var peek: Character {
        guard !isAtEnd else { return "\0" }
        return currentCharacter
    }
    
    private var peekNext: Character {
        guard current + 1 < source.count else { return "\0" }
        return source[source.index(source.startIndex, offsetBy: current + 1)]
    }
    
    private var startIndex: String.Index {
        source.index(source.startIndex, offsetBy: start)
    }
    
    private var currentIndex: String.Index {
        source.index(source.startIndex, offsetBy: current)
    }
    
    private func string() {
        // Advance until the string is terminated
        while peek != "\"" && !isAtEnd {
            if peek == "\n" { line += 1 } // Lox allows multi-line strings
            _ = advance()
        }
        
        guard !isAtEnd else {
            lox.error(line: line, message: "Unterminated string.")
            return
        }
        
        _ = advance()
        // Capture the string
        let end: String.Index = source.index(source.startIndex, offsetBy: current - 1)
        let value: String = String(source[startIndex..<end])
        addToken(type: .STRING, literal: .string(value: value))
    }
    
    private func number() {
        while peek.isNumber { _ = advance() }
        
        if peek == "." && peekNext.isNumber {
            _ = advance()
            while peek.isNumber { _ = advance() }
        }
        
        guard let number = Double(source[startIndex..<currentIndex]) else { return }
        addToken(type: .NUMBER, literal: .number(value: number))
    }
    
    private func identifier() {
        // Check if id is keyword
        while peek.isLetter { _ = advance() }
        let text: String = String(source[startIndex..<currentIndex])
        let type: TokenType = keywords[text] ?? .IDENTIFIER
        addToken(type)
    }
    
    let keywords: [String: TokenType] = ["and": TokenType.AND,
                                         "AND": TokenType.AND,
                                         "&&": TokenType.AND,
                                         "class": TokenType.CLASS,
                                         "else": TokenType.ELSE,
                                         "false": TokenType.FALSE,
                                         "for": TokenType.FOR,
                                         "fun": TokenType.FUN,
                                         "if": TokenType.IF,
                                         "nil": TokenType.NIL,
                                         "or": TokenType.OR,
                                         "OR": TokenType.OR,
                                         "||": TokenType.OR,
                                         "print": TokenType.PRINT,
                                         "return": TokenType.RETURN,
                                         "super": TokenType.SUPER,
                                         "this": TokenType.THIS,
                                         "true": TokenType.TRUE,
                                         "var": TokenType.VAR,
                                         "while": TokenType.WHILE]
}

