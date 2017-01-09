protocol Generator {
    func generate(_ ast: [AST]) -> String
}

class GeneratorImpl: Generator {
    
    typealias Handler = (_ ast: AST) -> String

    var nodeHandlers: [String:(AST) -> String]
    
    init() {
        nodeHandlers = [:]
        nodeHandlers["struct_decl"] = structOrClassDecl
        nodeHandlers["source_file"] = sourceFile
        nodeHandlers["var_decl"] = varDecl
        nodeHandlers["import_decl"] = importDecl
        nodeHandlers["pattern_binding_decl"] = nullHandler
        nodeHandlers["class_decl"] = structOrClassDecl
        nodeHandlers["constructor_decl"] = constructor_decl
    }
    
    func generate(_ asts: [AST]) -> String {
        return asts.map { eval($0) }.joined(separator: "\n\n")
    }
    
    func eval(_ ast: AST) -> String {
        guard !ast.implicit else { return "" }
        if let handler = nodeHandlers[ast.type] {
            return handler(ast)
        } else {
            return nullHandler(ast)
        }
    }
    
    func nullHandler(_ ast: AST) -> String { return "" }
    
    func importDecl(_ ast: AST) -> String { return "import \(ast.name!)" }
    
    func varDecl(_ ast: AST) -> String {
        let letOrVar = ast.attributes["let"] != nil ? "val" : "var"
        return "\(letOrVar) \(ast.name!): \(ast.attributes["type"]!)"
    }
    
    func sourceFile(_ ast: AST) -> String {
        return ast.elements.map { eval($0) }.filter { $0 != "" }.joined(separator: "\n")
    }
    
    func constructor_decl(_ ast: AST) -> String {
        return ""
    }
    
    func structOrClassDecl(_ ast: AST) -> String {
        let parameters = ast.elements.map { eval($0) }.filter { $0 != "" }.joined(separator: ", ")
        var inheritsText: String = ""
        if let inherits = ast.attributes["inherits"] {
            inheritsText = " : \(inherits)"
        }
        return "class \(ast.name!)(\(parameters))\(inheritsText) {}"
    }
}
