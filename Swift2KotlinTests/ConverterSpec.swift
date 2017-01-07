import Quick
import Nimble

class ConverterSpec: QuickSpec {
    override func spec() {
        describe("Converter") {
            let converter = Converter()
            
            describe("#convert") {
                fit("doesn't break") {
                    _ = converter.convertToKotlin("/tmp/foo.swift")
                }
            }
        }
    }
}
