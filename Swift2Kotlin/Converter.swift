class Converter {
    var tokenizer = Tokenizer()
    
    func convertToKotlin(_ swiftFilename: String) -> String {
        let output = Shell.runToStderr("swiftc", "-dump-ast", swiftFilename)
        return tokenizer.tokenize(output).map {token in token.toString() }.joined(separator: " ")
    }
}
