// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation

@main
struct Lox: ParsableCommand {
    @Argument(help: "The file to interpret")
    var script: String?
    
    var hadError: Bool = false
    
    mutating func run() throws {
        if let script {
            try runFile(path: script)
        } else {
            try runPrompt()
        }
    }
    
    private func runFile(path: String) throws {
        let input: String = try String(contentsOfFile: path, encoding: .utf8)
        run(source: input)
        if hadError {
            Foundation.exit(65)
        }
    }
    
    private mutating func runPrompt() throws {
        while true {
            print("> ", terminator: "")
            if let line = readLine(strippingNewline: true) {
                run(source: line)
                hadError = false
            }
        }
    }
    
    private func run(source: String) {
        let tokens: [Token] = Scanner(lox: self, source: source).scanTokens()
        
        for token in tokens {
            print(token)
        }
    }
    
    mutating func error(line: Int, message: String) {
        report(line: line, example: "", message: message)
    }
    
    private mutating func report(line: Int, example: String, message: String) {
        print("[line \(line)] Error \(example): \(message)")
        hadError = true
    }
}
