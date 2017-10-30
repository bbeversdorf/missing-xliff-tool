//
//  FileHandler.swift
//  MissingXliffTools
//
//  Created by brianbeversdorf on 11/11/17.
//  Copyright © 2017 brianbeversdorf. All rights reserved.
//

import Foundation

struct FileHandler {
    static func populateStringsFile(using dataSource: [TableRowData], comparingWith completeDatasource: [TableRowData], directory projectDirectory: URL?) {
        var newValues: [Int] = []
        for (index, element) in dataSource.enumerated() {
            guard element.transUnit.target?.value?.isEmpty == false &&
                completeDatasource.first(where: {
                    $0.transUnit.id == element.transUnit.id &&
                        $0.transUnit.target?.value?.isEmpty != false
                }) != nil else {
                    continue
            }
            newValues.append(index)
        }
        guard newValues.isEmpty == false else {
            return
        }
        newValues.forEach { index in
            guard let filePath = dataSource[index].file.translatedPath(),
                let newString = dataSource[index].transUnit.stringForStringsFile() else {
                    return
            }
            FileHandler.appendToFile(filePath: filePath, value: newString, directory: projectDirectory)
        }
    }
    private static func appendToFile(filePath: String, value: String, directory projectDirectory: URL?, amendProjectPath: Bool = true) {
        guard let data = value.data(using: .utf8, allowLossyConversion: false) else {
            return
        }
        let filePath: String = {
            if amendProjectPath {
                return projectDirectory?.appendingPathComponent(filePath).path ?? filePath
            }
            return filePath
        }()
        if FileManager.default.fileExists(atPath: filePath) {
            do {
                let fileHandle = try FileHandle(forWritingTo: URL(fileURLWithPath: filePath))
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            } catch {
                print("Cannot write to file")
                print(error)
            }
        } else {
            do {
                try data.write(to: URL(fileURLWithPath: filePath), options: .atomic)
            } catch {
                print("Can't write \(error)")
            }
        }
    }

    static func createXliff(using dataSource: [TableRowData], directory projectDirectory: URL?, amendProjectPath: Bool = true) {
        // TODO: Export Xliff
    }

    // TODO: Add item to insert prototypes
}
