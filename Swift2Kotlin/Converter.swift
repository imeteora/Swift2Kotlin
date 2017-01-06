class Converter {
    var tokenizer = Tokenizer()
    var parser = Parser()
    var generator = Generator()
    
    func convertToKotlin(_ swiftFilename: String) -> String {
        let output = Shell.runToStderr("swiftc", "-dump-ast", swiftFilename)
        let tokens = tokenizer.tokenize(output)
        let ast = parser.parse(tokens)
        return generator.generate(ast)
    }
}
