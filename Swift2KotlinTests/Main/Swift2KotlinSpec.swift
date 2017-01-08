import Quick
import Nimble

class SwiftToKotlinSpec: QuickSpec {
    override func spec() {
        describe("Converter") {
            let converter = ConverterImpl()
            describe("#convertToKotlin") {
                it("converts a simple struct") {
                    let tempFilename = "/tmp/foo.swift"
                    try! "class A { let a: Int = 1 }".write(toFile: tempFilename, atomically: true, encoding: String.Encoding.utf8)
                    expect(converter.convertSource(filenameArgs: [tempFilename])).to(equal("class A(val a: Int) {}"))
                }
            }
        }
    }
}
