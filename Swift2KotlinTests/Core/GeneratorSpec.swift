
import Quick
import Nimble

class GeneratorSpec: QuickSpec {
    override func spec() {
        describe("Generator") {
            let generator = GeneratorImpl()
            it("generates code for a struct without fields") {
                let ast = AST(type: "struct_decl", name: "A")
                let text = generator.generate([ast])
                
                expect(text).to(equal("class A() {}"))
            }

            it("generates code for a var_decl with let") {
                let ast = AST(type: "var_decl", name: "a", attributes: ["type":"Int", "let":""])
                let text = generator.generate([ast])
                
                expect(text).to(equal("val a: Int"))
            }
            
            it("generates code for a struct with fields") {
                let letAst = AST(type: "var_decl", name: "a", attributes: ["type":"Int", "let":""])
                let varAst = AST(type: "var_decl", name: "b", attributes: ["type":"Int"])
                let structAst = AST(type: "struct_decl", name: "A", elements: [letAst, varAst])
                let text = generator.generate([structAst])
                
                expect(text).to(equal("class A(val a: Int, var b: Int) {}"))
            }
            
            it("generates code for an import declaration") {
                let ast = AST(type: "import_decl", name: "A")
                let text = generator.generate([ast])
                
                expect(text).to(equal("import A"))

            }
            
            it("generates code for a class declaration") {
                let ast = AST(type: "class_decl", name: "A")
                let text = generator.generate([ast])
                
                expect(text).to(equal("class A() {}"))

            }
            
            it("supports subclassing on class declarations") {
                let ast = AST(type: "class_decl", name: "A", attributes: ["inherits": "B"])
                let text = generator.generate([ast])
                
                expect(text).to(equal("class A() : B {}"))
            }
        }
    }
}
