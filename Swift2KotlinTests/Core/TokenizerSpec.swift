import Quick
import Nimble

class TokenizerSpec: QuickSpec {
    override func spec() {
        describe("Tokenizer") {
            let tokenizer = TokenizerImpl()
            
            it("recognizes basic elements") {
                let tokens = tokenizer.tokenize("(some_symbol\n \"some_string\")")
                expect(tokens.count).to(equal(4))
                expect(tokens[0]).to(equal(Token.leftParen))
                expect(tokens[1]).to(equal(Token.symbol("some_symbol")))
                expect(tokens[2]).to(equal(Token.string("some_string")))
                expect(tokens[3]).to(equal(Token.rightParen))
            }
            
            it("recognizes key value pair") {
                let tokens = tokenizer.tokenize("(some_symbol type='foo' \"some string\" 'some other string' type2=bar.(file).baz:)")
                expect(tokens.count).to(equal(7))
                expect(tokens[0]).to(equal(Token.leftParen))
                expect(tokens[1]).to(equal(Token.symbol("some_symbol")))
                expect(tokens[2]).to(equal(Token.keyValue("type", "foo")))
                expect(tokens[3]).to(equal(Token.string("some string")))
                expect(tokens[4]).to(equal(Token.string("some other string")))
                expect(tokens[5]).to(equal(Token.keyValue("type2", "bar.(file).baz:")))
                expect(tokens[6]).to(equal(Token.rightParen))
            }

            it("recognizes key value pair with colon") {
                let tokens = tokenizer.tokenize("(some_symbol inherits: B)")
                expect(tokens.count).to(equal(4))
                expect(tokens[2]).to(equal(Token.keyValue("inherits", "B")))
            }
            
            it("skips tokens with @ in them") {
                let tokens = tokenizer.tokenize("(some_symbol foo@a:b bar)")
                expect(tokens.count).to(equal(4))
                expect(tokens[2]).to(equal(Token.symbol("bar")))
            }
            
            fit("handles nested square bracket values and returns them as []") {
                let tokens = tokenizer.tokenize("(some_symbol foo=[whatever - [whatever]])")
                expect(tokens.count).to(equal(4))
                expect(tokens[2]).to(equal(Token.keyValue("foo", "[]")))
            }
            
        }
    }
}
