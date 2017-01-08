import Quick
import Nimble

class FileListExpanderSpec: QuickSpec {
    override func spec() {
        describe("FileListExpander") {
            let expander = FileListExpanderImpl()
            let fm = FileManager.default
            let tempDir = "/tmp/_k2s/"
            
            func makeFiles(_ paths: [String]) {
                for path in paths {
                    fm.createFile(atPath: path, contents: nil, attributes: nil)
                }
            }
            
            func absoluteFilenames(_ relativePaths: String...) -> [String] {
                return relativePaths.map { tempDir + $0 }
            }
            
            beforeEach {
                if fm.fileExists(atPath: tempDir) {
                    try! fm.removeItem(atPath: tempDir)
                }
                try! fm.createDirectory(atPath: tempDir, withIntermediateDirectories: false, attributes: nil)
            }
            describe("#expand") {
                it("returns the filenames passed in if none are directories") {
                    let files = absoluteFilenames("a", "b")
                    makeFiles(files)
                    
                    expect(expander.expand(fileList: files)).to(equal(files))
                }
                
                it("skips names for files that do not exist") {
                    let files = absoluteFilenames("a", "b", "c")
                    var subsetOfFiles = files
                    subsetOfFiles.remove(at: 1)
                    makeFiles(subsetOfFiles)
                    
                    expect(files).toNot(haveCount(subsetOfFiles.count))
                    expect(expander.expand(fileList: files)).to(equal(subsetOfFiles))
                }
                
                it("expands directories to include swift files contained therein") {
                    let files = absoluteFilenames("a.swift", "b", "c.swift")
                    var expectedSubsetOfFiles = files
                    expectedSubsetOfFiles.remove(at: 1)
                    makeFiles(files)
                    
                    expect(expander.expand(fileList: [tempDir])).to(equal(expectedSubsetOfFiles))
                }
            }
        }
    }
}
