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
    
    static func symbol(_ s: Swift.String) -> Symbol { return Symbol(s) }
    static func string(_ s: Swift.String) -> String { return String(s) }
    
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
            var result = ""
            while nextChar()! != c {
                result.append(getChar()!)
            }
            return result
        }
        
        func getUntilBlank() -> String { return getUntil(" ") }
        
        func skipNonWhiteAndSingleQuotedText() {
            while let char = nextChar() {
                if char == "'" {
                    _ = getChar()
                    _ = getUntil("'")
                } else if char == "(" {
                    _ = getChar()
                    _ = getUntil(")")
                } else if char == " " || char == ")" { return }
                _ = getChar()
            }
        }
        
        while let char = skipWhiteSpace() {
            switch char {
            case "(":
                _ = getChar()
                tokens.append(Token.leftParen)
                tokens.append(Token.symbol(getUntilBlank()))
            case ")":
                _ = getChar()
                tokens.append(Token.rightParen)
            case "\"":
                _ = getChar()
                tokens.append(Token.string(getUntil("\"")));
                _ = getChar()
            default:
                _ = skipNonWhiteAndSingleQuotedText()
            }
        }
        
        return tokens
    }
}
