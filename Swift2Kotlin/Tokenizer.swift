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
    
    private func quoteIfNecessary() {
        
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

class Tokenizer {
    func tokenize(_ s: String) -> [Token] {
        var tokens = [Token]()
        let characters = s.characters.map { $0 }
        var index = 0
        func getChar() -> Character? {
            if index < characters.count {
                index += 1
                return characters[index-1]
            } else {  return nil }
        }
        
        func nextChar() -> Character? {
            if index < characters.count {
                return characters[index]
            } else {  return nil }
        }
        
        func skipWhiteSpace() -> Character? {
            while let char = nextChar() {
                guard [" ", "\n"].index(of: char) != nil else { return char }
                _ = getChar()
            }
            return nil
        }
        
        func getUntil(_ c: Character) -> String {
            return getUntil() { char in char == c }
        }
        
        func getUntil(closure: (Character) -> Bool) -> String {
            var result = ""
            while !closure(nextChar()!) {
                result.append(getChar()!)
            }
            return result
        }
        
        func getUntilBlank() -> String { return getUntil(" ") }
        
        func getBalanced() -> String {
            if nextChar() == "'" {
                _ = getChar()
                let result = getUntil("'")
                _ = getChar()
                return result
            }
            var result = ""
            while let char = nextChar() {
                if char == "(" {
                    result.append(getChar()!)
                    result.append(getUntil(")"))
                    result.append(getChar()!)
                } else if char == " " || char == ")" { return result }
                result.append(getChar()!)
            }
            return result
        }
        
        while let char = skipWhiteSpace() {
            switch char {
            case "(":
                _ = getChar()
                tokens.append(Token.leftParen)
            case ")":
                _ = getChar()
                tokens.append(Token.rightParen)
            case "\"":
                _ = getChar()
                tokens.append(Token.string(getUntil("\"")));
                _ = getChar()
            case "'":
                _ = getChar()
                tokens.append(Token.string(getUntil("'")));
                _ = getChar()
            default:
                let key = getUntil() { c in c == "=" || c == " " || c == ")" }
                if nextChar()! == "=" {
                    _ = getChar()
                    let value = getBalanced()
                    tokens.append(Token.keyValue(key, value))
                } else {
                    tokens.append(Token.symbol(key))
                }
            }
        }
        
        return tokens
    }
}
