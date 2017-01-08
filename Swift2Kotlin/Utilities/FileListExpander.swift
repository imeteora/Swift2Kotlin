import Foundation

protocol FileListExpander {
    func expand(fileList: [String]) -> [String]
}

class FileListExpanderImpl: FileListExpander {
    typealias Path = String
    
    let fileManager = FileManager.default
    let shell: Shell
    
    init(shell: Shell = ShellImpl()) {
        self.shell = shell
    }
    
    func expand(fileList: [String]) -> [String] {
        return fileList.map { (filename: String) -> [String] in
            var isDir: ObjCBool = false
            if !fileManager.fileExists(atPath: filename, isDirectory: &isDir) { return [] }
            return isDir.boolValue ? expandDirectory(path: filename) : [filename]
            }.flatMap { $0 }
    }
    
    func expandDirectory(path: Path) -> [String] {
        let paths = fileManager.subpaths(atPath: path)!
        return paths.filter { $0.range(of: ".swift") != nil }.map { path + $0 }
    }

}
