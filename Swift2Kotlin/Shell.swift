import Foundation

class Shell {
    static func run(_ args: [String], closure: (Process) -> ()) {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        closure(task)
        task.launch()
        task.waitUntilExit()
    }
    
    static func runToStdout(_ args: String...) -> String {
        let pipe = Pipe()
        run(args) { $0.standardOutput = pipe }
        return String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8)!
    }
    
    static func runToStderr(_ args: String...) -> String {
        let pipe = Pipe()
        run(args) { $0.standardError = pipe }
        return String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8)!
    }
}
