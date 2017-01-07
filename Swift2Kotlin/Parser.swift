class Parser {
    func parse(_ tokens: [Token]) -> AST {
        var index = 0
        func getToken() -> Token {
            index += 1
            return tokens[index-1]
        }
        
        func nextToken() -> Token { return tokens[index] }
        
        func innerParse() -> AST {
            guard getToken() == Token.leftParen else { fatalError() }
            guard let typeToken = getToken() as? Token.Symbol else { fatalError() }
            var implicit = false
            var name: String? = nil
            var attributes = [String:String]()
            var elements = [AST]()
            if let implicitToken = nextToken() as? Token.Symbol, implicitToken.value == "implicit" {
                _ = getToken()
                implicit = true
            }
            
            if let nameToken = nextToken() as? Token.String {
                _ = getToken()
                name = nameToken.value
            }
            
            while true {
                switch nextToken() {
                case Token.rightParen:
                    _ = getToken()
                    return AST(type: typeToken.value, implicit: implicit, name: name, attributes: attributes, elements: elements)
                case let stringToken as Token.String:
                    _ = getToken()
                    attributes[stringToken.value] = ""
                case let symbolToken as Token.Symbol:
                    _ = getToken()
                    attributes[symbolToken.value] = ""
                case let keyValue as Token.KeyValue:
                    _ = getToken()
                    attributes[keyValue.key] = keyValue.value
                case Token.leftParen:
                    elements.append(innerParse())
                default:
                    fatalError()
                }
            }
        }
        
        return innerParse()
    }
}
