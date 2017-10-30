//
//  CSVFileParser.swift
//  MissingXliffTools
//
//  Created by brianbeversdorf on 11/6/17.
//  Copyright © 2017 brianbeversdorf. All rights reserved.
//

import Cocoa

class CSVFileParser: NSObject {
    private var parsedXliff = Xliff()
    private override init() { }
    static func parse(filePath: String) -> Xliff? {
        let fileParser = CSVFileParser()
        fileParser.parser(filePath: filePath)
        return fileParser.parsedXliff
    }
    func parser(filePath: String) {
        let csvString = (try? String.init(contentsOfFile: filePath)) ?? ""
        let csv = try? CSV(string: csvString)
        let xliff = Xliff()
        var file: File?
        var body: Body?
        guard let firstRow = csv?.headerRow else {
            return
        }
        csv?.forEach { row in
            guard row != firstRow else {
                return
            }
            guard row[0].isEmpty == false && row[1].isEmpty == false else {
                return
            }
            if row[0] != file?.original {
                file = File(original: row[0], sourceLanguage: "en", dataType: nil, targetLanguage: "es")
                guard let file = file else {
                    return
                }
                xliff.files.append(file)
                body = Body()
                guard let body = body else {
                    return
                }
                file.body = body
            }
            // We need to reverse escaped \n
            let id = row[1].replacingOccurrences(of: "\\n", with: "\n")
            let source = row[2].replacingOccurrences(of: "\\n", with: "\n")
            let note = row[3].replacingOccurrences(of: "\\n", with: "\n")
            let transUnit = TransUnit(id: id)
            transUnit.source = Source(value: source)
            transUnit.note = Note(value: note)
            var target: String? = row[4]
            target = target?.replacingOccurrences(of: "\r", with: "")
            target = target?.replacingOccurrences(of: "\\n", with: "\n")
            target = target?.isEmpty != false ? nil : target
            transUnit.target = Target(value: target)
            body?.transUnits.append(transUnit)
        }
        parsedXliff = xliff
    }
}
