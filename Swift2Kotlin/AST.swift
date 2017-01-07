struct AST {
    let type: String
    let implicit: Bool
    let name: String?
    let attributes: [String:String]
    let elements: [AST]
    
    init(type: String, implicit: Bool = false, name: String? = nil, attributes: [String:String] = [:], elements: [AST] = []) {
        self.type = type
        self.implicit = implicit
        self.name = name
        self.attributes = attributes
        self.elements = elements
    }
}
