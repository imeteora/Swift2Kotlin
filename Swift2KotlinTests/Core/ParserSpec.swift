import Quick
import Nimble

class ParserSpec: QuickSpec {
    override func spec() {
        describe("Parser") {
            let parser = ParserImpl()
            it("parsers a simple tree correctly") {
                let ast = parser.parse(TokenizerImpl().tokenize("(some_symbol \"some name\" type='foo' \"some string\" 'some other string' type2=bar.(file).baz)"))[0]
                expect(ast.type).to(equal("some_symbol"))
                expect(ast.implicit).to(beFalse())
                expect(ast.name).to(equal("some name"))
                expect(ast.attributes).to(haveCount(4))
                expect(ast.attributes["type"]!).to(equal("foo"))
                expect(ast.attributes["some string"]).toNot(beNil())
                expect(ast.attributes["some other string"]).toNot(beNil())
                expect(ast.attributes["type2"]!).to(equal("bar.(file).baz"))
                expect(ast.elements).to(haveCount(0))
            }
            
            it("parses nested trees") {
                let ast = parser.parse(TokenizerImpl().tokenize("(some_symbol implicit (a) (b (c) (d)))"))[0]
                expect(ast.type).to(equal("some_symbol"))
                expect(ast.implicit).to(beTrue())
                expect(ast.name).to(beNil())
                expect(ast.attributes).to(haveCount(0))
                expect(ast.elements).to(haveCount(2))
                expect(ast.elements[0].type).to(equal("a"))
                expect(ast.elements[1].type).to(equal("b"))
                expect(ast.elements[1].elements).to(haveCount(2))
                expect(ast.elements[1].elements[0].type).to(equal("c"))
                expect(ast.elements[1].elements[1].type).to(equal("d"))
            }
        }
    }
}
