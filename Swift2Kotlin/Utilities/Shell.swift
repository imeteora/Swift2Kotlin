import Foundation

protocol Shell {
    func runToStdout(command: String, args: [String]) -> String
    func runToStderr(command: String, args: [String]) -> String
}

class ShellImpl: Shell {
    func run(_ command: String, args: [String], closure: (Process, Pipe) -> ()) -> String {
        let process = Process()
        let pipe = Pipe()
        process.launchPath = command
        process.arguments = args
        closure(process, pipe)
        process.launch()
        let output = String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8)!
        process.waitUntilExit()
        return output
    }
    
    func runToStdout(command: String, args: [String]) -> String {
        return run(command, args: args) { $0.standardOutput = $1 }
    }
    
    func runToStderr(command: String, args: [String]) -> String {
        return run(command, args: args) { $0.standardError = $1 }
    }
}
