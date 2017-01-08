protocol Converter {
    func convertSource(filenameArgs: [String]) -> String
}

typealias ASTText = String
typealias KotlinText = String

class ConverterImpl: Converter {
    let tokenizer: Tokenizer
    let parser:Parser
    let generator: Generator
    let shell: Shell
    let fileListExpander: FileListExpander
    
    init(tokenizer: Tokenizer = TokenizerImpl(), parser: Parser = ParserImpl(), generator: Generator = GeneratorImpl(), shell: Shell = ShellImpl(), fileListExpander: FileListExpander = FileListExpanderImpl()) {
        self.tokenizer = tokenizer
        self.parser = parser
        self.generator = generator
        self.shell = shell
        self.fileListExpander = fileListExpander
    }
    
    func convertSource(filenameArgs: [String]) -> String {
        let filenames = fileListExpander.expand(fileList: filenameArgs)
        let output = shell.runToStderr(command: "/usr/bin/swiftc", args: ["-dump-ast"] + filenames)
        let tokens = tokenizer.tokenize(output)
        let asts = parser.parse(tokens)
        return generator.generate(asts)
    }
    
    func convertAST(filename: String) -> KotlinText {
        let fileContents = try! String(contentsOfFile: filename)
        return convertAST(string: fileContents)
    }
    
    func convertAST(string: ASTText) -> KotlinText {
        let tokens = tokenizer.tokenize(string)
        let asts = parser.parse(tokens)
        return generator.generate(asts)
    }
}


    
//    func convertFiles(sourceRelativePath: Path, sourceBaseURL: URL, destBaseURL: URL) {
//        let paths = fileManager.subpaths(atPath: sourceBaseURL.path)!
//        var derivedPaths: [(String, String)] = []
//        for path in paths {
//            guard path.range(of: ".swift") != nil else { continue }
//            let range = path.range(of: sourceRelativePath)
//            guard sourceRelativePath == "" || range?.lowerBound == path.startIndex else { continue }
//            let result = convertFile(relativePath: path, sourceBaseURL: sourceBaseURL, destBaseURL: destBaseURL)
//            if let successResult = result {
//                derivedPaths.append(successResult)
//            }
//        }
//        let inputFiles = derivedPaths.map {(s, _) -> String in s}
//        let args = ["/usr/bin/swiftc", "-dump-ast", "-target", "arm64-apple-ios9.0", "-sdk", "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS10.2.sdk"] + inputFiles + ["-F", "/Users/pivotal/Library/Developer/Xcode/DerivedData/Nimble-cebloqhjfrepoefychlrvgxhcsug/Build/Products/Release", "-F", "/Users/pivotal/Library/Developer/Xcode/DerivedData/Quick-flknbkzghjjugedfhjkyjttaixci/Build/Products/Release"]
//        print(args.joined(separator: " "))
//        let output = shell(args)
//        try! output.write(toFile: "/tmp/transpilerOut.txt", atomically: true, encoding: String.Encoding.utf8)
//    }

