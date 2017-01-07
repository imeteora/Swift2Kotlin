import Quick
import Nimble

class SwiftToKotlinSpec: QuickSpec {
    override func spec() {
        describe("Converter") {
            let converter = Converter()
            describe("#convertToKotlin") {
                it("converts a simple struct") {
                    let tempFilename = "/tmp/foo.swift"
                    try! "class A { let a: Int = 1 }".write(toFile: tempFilename, atomically: true, encoding: String.Encoding.utf8)
                    expect(converter.convertToKotlin(tempFilename)).to(equal("class A(val a: Int) {}"))
                }
                
                fit("converts us") {
                    let filename = "/Users/pivotal/workspace/Swift2Kotlin/Swift2KotlinTests/"
                    expect(converter.convertToKotlin(filename)).to(equal("some kotlin"))
                }
            }
        }
    }
}
