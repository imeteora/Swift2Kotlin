class Swift2Kotlin {
    var converter = Converter()
    func run() {
        if CommandLine.arguments.count == 1 { ConsoleIO.printUsage() ; return }
        if CommandLine.arguments.count == 2 {
            let filename = CommandLine.arguments[1]
            print(converter.convertToKotlin(filename))
        }
    }
}

//
//  main.swift
//  SwiftToKotlin
//
//  Created by Pivotal on 1/4/17.
//  Copyright © 2017 Pivotal. All rights reserved.
//

//import Foundation
//
//typealias Path = String
//
//let fileManager = FileManager.default
//
//import Foundation
//
//@discardableResult
//func shell(_ args: [String]) -> String {
//    let task = Process()
//    task.launchPath = "/usr/bin/env"
//    task.arguments = args
//    let outpipe = Pipe()
//    task.standardOutput = outpipe
//    task.launch()
//    task.waitUntilExit()
//    
//    return String(data: outpipe.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8)!
//}
//
//func convertFile(relativePath: Path, sourceBaseURL: URL, destBaseURL: URL) -> (String, String)? {
//    let url = URL(fileURLWithPath: relativePath, isDirectory: false, relativeTo: sourceBaseURL)
//    var isDir: ObjCBool = false
//    let fileExists = fileManager.fileExists(atPath: url.path, isDirectory: &isDir)
//    guard fileExists && !isDir.boolValue else { return nil }
//    let destURL = URL(fileURLWithPath: relativePath, isDirectory: false, relativeTo: destBaseURL)
//    let destDir = destURL.deletingLastPathComponent().path
//    let destPath = destURL.path + ".ast"
//    shell(["mkdir", "-p", destDir])
//    return (url.path, destPath)
//}
//
//func convertFiles(sourceRelativePath: Path, sourceBaseURL: URL, destBaseURL: URL) {
//    let paths = fileManager.subpaths(atPath: sourceBaseURL.path)!
//    var derivedPaths: [(String, String)] = []
//    for path in paths {
//        guard path.range(of: ".swift") != nil else { continue }
//        let range = path.range(of: sourceRelativePath)
//        guard sourceRelativePath == "" || range?.lowerBound == path.startIndex else { continue }
//        let result = convertFile(relativePath: path, sourceBaseURL: sourceBaseURL, destBaseURL: destBaseURL)
//        if let successResult = result {
//            derivedPaths.append(successResult)
//        }
//    }
//    let inputFiles = derivedPaths.map {(s, _) -> String in s}
//    let args = ["/usr/bin/swiftc", "-dump-ast", "-target", "arm64-apple-ios9.0", "-sdk", "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS10.2.sdk"] + inputFiles + ["-F", "/Users/palfvin/workspace/bk-native-app/Dependencies/Carthage/Build/iOS", "-F", "/Users/palfvin/workspace/bk-native-app/Dependencies/Frameworks", "-F", "/Users/palfvin/workspace/bk-native-app/Dependencies/Frameworks/GoogleMaps"]
//    print(args.joined(separator: " "))
//    let output = shell(args)
//    try! output.write(toFile: "/tmp/transpilerOut.txt", atomically: true, encoding: String.Encoding.utf8)
//}
//
//let sourceBaseURL = URL(fileURLWithPath: "/Users/palfvin/workspace/bk-native-app/BKO/")
//let destBaseURL = URL(fileURLWithPath: "/Users/palfvin/workspace/Swift2Kotlin/Output/")
//let sourceRelativePath = ""
//convertFiles(sourceRelativePath: sourceRelativePath, sourceBaseURL: sourceBaseURL, destBaseURL: destBaseURL)
