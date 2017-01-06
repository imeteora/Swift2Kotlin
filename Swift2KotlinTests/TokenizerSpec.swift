import Quick
import Nimble

func matchToken(_ expectedValue: Token?) -> MatcherFunc<Token?> {
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal <\(expectedValue)>"
        if let actualValue = try actualExpression.evaluate() {
            guard actualValue !== expectedValue else { return true }
            if let actual = actualValue as? Token.String, let expected = expectedValue as? Token.String {
                return actual.value == expected.value
            }
            if let actual = actualValue as? Token.Symbol, let expected = expectedValue as? Token.Symbol {
                return actual.value == expected.value
            }
            return false
        } else {
            return false
        }
    }
}


class TokenizerSpec: QuickSpec {
    override func spec() {
        describe("Tokenizer") {
            let tokenizer = Tokenizer()
            
            it("recognizes basic elements") {
                let tokens = tokenizer.tokenize("(some_symbol \"some_string\")")
                expect(tokens.count).to(equal(4))
                expect(tokens[0]).to(matchToken(Token.leftParen))
                expect(tokens[1]).to(matchToken(Token.symbol("some_symbol")))
                expect(tokens[2]).to(matchToken(Token.string("some_string")))
                expect(tokens[3]).to(matchToken(Token.rightParen))
            }
            
            it("skips elements we don't care about") {
                let tokens = tokenizer.tokenize("(some_symbol some@thing some_other=thing \"some_string\" some_thing_on_the_end)")
                expect(tokens.count).to(equal(4))
                expect(tokens[0]).to(matchToken(Token.leftParen))
                expect(tokens[1]).to(matchToken(Token.symbol("some_symbol")))
                expect(tokens[2]).to(matchToken(Token.string("some_string")))
                expect(tokens[3]).to(matchToken(Token.rightParen))
            }

        }
    }
}
