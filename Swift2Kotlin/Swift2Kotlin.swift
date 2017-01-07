class Swift2Kotlin {
    var converter = Converter()
    func run() {
        if CommandLine.arguments.count == 1 { ConsoleIO.printUsage() ; return }
        if CommandLine.arguments.count == 2 {
            let filename = CommandLine.arguments[1]
            if filename.characters.last == "/" {
                convertFiles(relativePath: "", sourceBaseURL: filename, destBaseURL: filename)
            } else {
                print(converter.convertToKotlin(filename))
            }
        }
    }
    
    func convertFile(relativePath: Path, sourceBaseURL: URL, destBaseURL: URL) -> (String, String)? {
        let url = URL(fileURLWithPath: relativePath, isDirectory: false, relativeTo: sourceBaseURL)
        var isDir: ObjCBool = false
        let fileExists = fileManager.fileExists(atPath: url.path, isDirectory: &isDir)
        guard fileExists && !isDir.boolValue else { return nil }
        let destURL = URL(fileURLWithPath: relativePath, isDirectory: false, relativeTo: destBaseURL)
        let destDir = destURL.deletingLastPathComponent().path
        let destPath = destURL.path + ".ast"
        shell(["mkdir", "-p", destDir])
        return (url.path, destPath)
    }
    
    func convertFiles(sourceRelativePath: Path, sourceBaseURL: URL, destBaseURL: URL) {
        let paths = fileManager.subpaths(atPath: sourceBaseURL.path)!
        var derivedPaths: [(String, String)] = []
        for path in paths {
            guard path.range(of: ".swift") != nil else { continue }
            let range = path.range(of: sourceRelativePath)
            guard sourceRelativePath == "" || range?.lowerBound == path.startIndex else { continue }
            let result = convertFile(relativePath: path, sourceBaseURL: sourceBaseURL, destBaseURL: destBaseURL)
            if let successResult = result {
                derivedPaths.append(successResult)
            }
        }
        let inputFiles = derivedPaths.map {(s, _) -> String in s}
        let args = ["/usr/bin/swiftc", "-dump-ast", "-target", "arm64-apple-ios9.0", "-sdk", "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS10.2.sdk"] + inputFiles + ["-F", "/Users/pivotal/Library/Developer/Xcode/DerivedData/Nimble-cebloqhjfrepoefychlrvgxhcsug/Build/Products/Release", "-F", "/Users/pivotal/Library/Developer/Xcode/DerivedData/Quick-flknbkzghjjugedfhjkyjttaixci/Build/Products/Release"]
        print(args.joined(separator: " "))
        let output = shell(args)
        try! output.write(toFile: "/tmp/transpilerOut.txt", atomically: true, encoding: String.Encoding.utf8)
    }
    
}
