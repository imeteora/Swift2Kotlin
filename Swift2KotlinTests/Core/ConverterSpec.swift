import Quick
import Nimble

class ConverterSpec: QuickSpec {
    override func spec() {
        describe("Converter") {
            let converter = ConverterImpl()
            
            describe("#convertAST") {
                fit("can process a snapshot of itself") {
                    let text = converter.convertAST(filename: "/Users/palfvin/workspace/Swift2Kotlin/Swift2KotlinTests/Fixtures/TokenizerAST.txt")
                    expect(text).to(equal("some kotlin"))
                }
            }
            
            describe("#convertSource") {
                it("can process a snapshot of itself") {
                    let text = converter.convertSource(filenameArgs: ["/Users/palfvin/workspace/Swift2Kotlin/Swift2Kotlin/"])
                    expect(text).to(equal("some kotlin"))
                }
            }
        }
    }
}
