protocol Tokenizer {
    func tokenize(_ s: String) -> [Token]
}

class TokenizerImpl: Tokenizer {
    func tokenize(_ s: String) -> [Token] {
        var tokens = [Token]()
        let characters = s.characters.map { $0 }
        var index = 0
        var line = 1
        var nesting = 0
        func getChar() -> Character? {
            if index < characters.count {
                let char = characters[index]
                if char == "\n" {
                    line += 1
                    var i = index
                    while true {
                        i += 1
                        guard i < characters.count else {
                            index += 1
                            return char
                        }
                        if characters[i] != " " { break }
                    }
                    
                    if characters[i] == "(" {
                        print("\(Double(i-index)/2.0-Double(nesting)):\(nesting):\(i-index):\(line)")
                    }
                    if nesting == 0 {
                        print("Back to zero at \(line)")
                    }
                }
                index += 1
                return char
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
        
        func getDoubleQuotedString() -> String {
            _ = getChar()
            let result = getUntil { c in
                if c == "\\" { _ = getChar() }
                return c == "\""
            }
            _ = getChar()
            return result
        }
        
        func getBalanced() -> String {
            if nextChar() == "'" {
                _ = getChar()
                let result = getUntil("'")
                _ = getChar()
                return result
            }
            if nextChar() == "[" {
                getNestedBrackets()
                return "[]"
            }
            
            if nextChar() == "\"" {
                return getDoubleQuotedString()
            }
            var result = ""
            while let char = nextChar() {
                if char == "(" {
                    result.append(getChar()!)
                    result.append(getUntil(")"))
                    result.append(getChar()!)
                } else if char == " " || char == ")" || char == "\n" { return result }
                result.append(getChar()!)
            }
            return result
        }
        
        func getNestedBrackets() {
            var nesting = 1
            _ = getChar()
            while nesting > 0 {
                switch getChar()! {
                case "[":
                    nesting += 1
                case "]":
                    nesting -= 1
                default:
                    break
                }
            }
        }
        
        while let char = skipWhiteSpace() {
            if index == 0 && char != "(" {
                fatalError("AST does not start with left parenthesis")
            }
            switch char {
            case "[":
                getNestedBrackets()
            case "(":
                _ = getChar()
                nesting += 1
                tokens.append(Token.leftParen)
            case ")":
                _ = getChar()
                nesting -= 1
                tokens.append(Token.rightParen)
            case "\"":
                let result = getDoubleQuotedString()
                tokens.append(Token.string(result))
            case "'":
                _ = getChar()
                tokens.append(Token.string(getUntil("'")))
                _ = getChar()
            default:
                let key = getUntil() { c in
                    ["=", " ", "(", ")", "\n", ":", "@"].index(of: c) != nil
                }
                switch nextChar()! {
                case "(":
                    while nextChar() != ")" {
                        _ = getChar()
                    }
                    _ = getChar()
                case "@":
                    _ = getBalanced()
                case "=":
                    _ = getChar()
                    let value = getBalanced()
                    tokens.append(Token.keyValue(key, value))
                case ":":
                    _ = getChar()
                    guard getChar() == " " else {
                        fatalError()
                    }
                    let value = getBalanced()
                    tokens.append(Token.keyValue(key, value))
                default:
                    tokens.append(Token.symbol(key))
                }
            }
        }
        
        return tokens
    }
}
