//
//  Swift2KotlinUITests.swift
//  Swift2KotlinUITests
//
//  Created by Pivotal on 1/5/17.
//  Copyright © 2017 Pivotal. All rights reserved.
//

import XCTest
import Foundation

class Swift2KotlinUITests: XCTestCase {
    
    var appPath: String!
    let workPath = "/tmp"
    
    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: type(of: self))
        let dir = bundle.object(forInfoDictionaryKey: "Executable directory") as! String
        appPath = "\(dir)/Swift2Kotlin"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUsage() {
        let output = Shell.runToStdout(appPath)
        let expectedOutput = ["usage:", "Swift2Kotlin -a string1 string2", "or", "Swift2Kotlin -p string", "or", "Swift2Kotlin -h to show usage information", "Type Swift2Kotlin without an option to enter interactive mode.\n"].joined(separator: "\n")
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testSimpleFile() {
        let tempSource = "\(workPath)/foo.swift"
        try! "class A { let a: Int = 1 }".write(toFile: tempSource, atomically: true, encoding: String.Encoding.utf8)
        let output = Shell.runToStdout(appPath, tempSource)
        XCTAssertEqual(output, "class A(val a: Int) {}\n")
    }
    
    func testMyself() {
        let source = "/Users/pivotal/Swift2Kotlin/Swift2KotlinUITests/Swift2KotlinUITests.swift"
        let output = Shell.runToStdout(appPath, source)
        XCTAssertEqual(output, "something else\n")
    }
}
