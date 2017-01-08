import Foundation

protocol Shell {
    func runToStdout(command: String, args: [String]) -> String
    func runToStderr(command: String, args: [String]) -> String
}

class ShellImpl: Shell {
    func run(_ command: String, args: [String], closure: (Process) -> ()) {
        let task = Process()
        task.launchPath = command
        task.arguments = args
        let commandString = ([command] + args).joined(separator: " ")
        try! commandString.write(toFile: "/tmp/command", atomically: true, encoding: String.Encoding.utf8)
//        closure(task)
        task.launch()
        task.waitUntilExit()
    }
    
    func runToStdout(command: String, args: [String]) -> String {
        let pipe = Pipe()
        run(command, args: args) { $0.standardOutput = pipe }
        return String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8)!
    }
    
    func runToStderr(command: String, args: [String]) -> String {
        let pipe = Pipe()
        run(command, args: args) { $0.standardError = pipe }
        return String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8)!
    }
}

import Foundation

func test() {
    func innerTest(filenames: String...) {
        let task = Process()
        let pipe = Pipe()
        let tempDir = "/Users/palfvin/workspace/Swift2Kotlin/Swift2Kotlin/Datatypes/"
        task.launchPath = "/usr/bin/swiftc"
        let inputPaths = filenames.map { tempDir + $0 + ".swift" }
        let outputFile = tempDir + filenames.joined() + ".ast"
        task.arguments = ["-dump-ast"] + inputPaths
        task.standardError = pipe
        task.launch()
        task.waitUntilExit()
        try! String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8)!.write(toFile: outputFile, atomically: true, encoding: String.Encoding.utf8)
    }
    
    innerTest(filenames: "AST")
    innerTest(filenames: "Token")
    innerTest(filenames: "AST", "Token")
}

test()



