protocol Swift2Kotlin {
    func run()
}

class Swift2KotlinImpl: Swift2Kotlin {
    let converter: Converter
    
    init(converter: Converter = ConverterImpl()) {
        self.converter = converter
    }
    
    func run() {
        if CommandLine.arguments.count == 1 { ConsoleIO.printUsage() ; return }
        let filenames = CommandLine.arguments[1..<CommandLine.arguments.count]
        _ = converter.convertSource(filenameArgs: Array(filenames))
    }
}
