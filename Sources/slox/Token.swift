public indirect enum LiteralType: Equatable, Hashable {
    case string(value: String)
    case number(value: Double)
    case none
}

struct Token: Hashable, Equatable, CustomStringConvertible {
    let type: TokenType
    let lexeme: String
    let literal: LiteralType
    let line: Int
    
    var description: String {
        return "\(type) \(lexeme) \(literal)"
    }
    
    static func == (lhs: Token, rhs: Token) -> Bool {
        return lhs.type == rhs.type &&
            lhs.lexeme == rhs.lexeme &&
            rhs.literal == lhs.literal
    }
}
