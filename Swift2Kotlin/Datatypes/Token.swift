class Token: Equatable {
    private class LeftParen: Token {}
    static let leftParen: Token = LeftParen()
    private class RightParen: Token {}
    static let rightParen: Token = RightParen()
    
    class String: Token {
        let value: Swift.String
        init(_ value: Swift.String) { self.value = value }
    }
    
    class Symbol: Token {
        let value: Swift.String
        init(_ value: Swift.String) { self.value = value }
    }
    
    class KeyValue: Token {
        let key: Swift.String
        let value: Swift.String
        init(_ key: Swift.String, _ value: Swift.String) {
            self.key = key
            self.value = value
        }
    }
    
    static func symbol(_ s: Swift.String) -> Symbol { return Symbol(s) }
    static func string(_ s: Swift.String) -> String { return String(s) }
    static func keyValue(_ k: Swift.String, _ v: Swift.String) -> KeyValue { return KeyValue(k, v) }
    
    func toString() -> Swift.String {
        switch self {
        case Token.leftParen:
            return "("
        case Token.rightParen:
            return ")"
        case let token as Token.String:
            return token.value
        case let token as Token.Symbol:
            return token.value
        case let token as Token.KeyValue:
            return "\(token.key)=\(token.value)"
        default:
            fatalError()
        }
    }
}

func ==(lhs: Token, rhs: Token) -> Bool {
    if let lhs = lhs as? Token.String, let rhs = rhs as? Token.String {
        return lhs.value == rhs.value
    }
    if let lhs = lhs as? Token.Symbol, let rhs = rhs as? Token.Symbol {
        return lhs.value == rhs.value
    }
    if let lhs = lhs as? Token.KeyValue, let rhs = rhs as? Token.KeyValue {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
    return lhs === rhs
}

