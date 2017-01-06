import Quick
import Nimble

class SwiftToKotlinSpec: QuickSpec {
    override func spec() {
        describe("Converter") {
            let converter = Converter()
            describe("#convertToKotlin") {
                fit("converts a simple struct") {
                    let tempFilename = "/tmp/foo.swift"
                    try! "struct A {let a: Int}".write(toFile: tempFilename, atomically: true, encoding: String.Encoding.utf8)
                    expect(converter.convertToKotlin(tempFilename)).to(equal("class A(val a: Int) {}"))
                }
            }
        }
    }
}
