//
//  Parser.swift
//  xliff2csv
//
//  Created by brianbeversdorf on 10/26/17.
//  Copyright © 2017 brianbeversdorf. All rights reserved.
//

import Foundation

class XliffFileParser: NSObject, XMLParserDelegate {
    private var xmlStack: [Any] = []
    private var parsedXliff = Xliff()
    private override init() { }
    static func parse(filePath: String) -> Xliff? {
        guard let data = FileManager.default.contents(atPath: filePath) else {
            return nil
        }
        let fileParser = XliffFileParser()
        let parser = XMLParser(data: data)
        parser.delegate = fileParser
        parser.parse()
        return fileParser.parsedXliff
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        switch elementName {
        case "xliff":
            break
        case "file":
            let original = attributeDict["original"]
            let sourceLanguage = attributeDict["source-language"]
            let dataType = attributeDict["datatype"]
            let targetLanguage = attributeDict["target-language"]
            let file = File(original: original, sourceLanguage: sourceLanguage, dataType: dataType, targetLanguage: targetLanguage)
            parsedXliff.files.append(file)
            xmlStack.append(file)
        case "header":
            let header = Header()
            if let file = xmlStack.last as? File {
                file.header = header
            }
            xmlStack.append(header)
        case "tool":
            let toolId = attributeDict["tool-id"]
            let toolName = attributeDict["tool-name"]
            let toolVersion = attributeDict["tool-version"]
            let buildNum = attributeDict["build-num"]
            let tool = Tool(toolId: toolId, toolName: toolName, toolVersion: toolVersion, buildNum: buildNum)
            if let header = xmlStack.last as? Header {
                header.tool = tool
            }
            xmlStack.append(tool)
        case "body":
            let body = Body()
            if let file = xmlStack.last as? File {
                file.body = body
            }
            xmlStack.append(body)
        case "trans-unit":
            let id = attributeDict["id"]
            let transUnit = TransUnit(id: id)
            if let body = xmlStack.last as? Body {
                body.transUnits.append(transUnit)
            }
            xmlStack.append(transUnit)
        case "source":
            let source = Source(value: nil)
            if let transUnit = xmlStack.last as? TransUnit {
                transUnit.source = source
            }
            xmlStack.append(source)
        case "target":
            let target = Target(value: nil)

            if let transUnit = xmlStack.last as? TransUnit {
                transUnit.target = target
            }
            xmlStack.append(target)
        case "note":
            let note = Note(value: nil)
            if let transUnit = xmlStack.last as? TransUnit {
                transUnit.note = note
            }
            xmlStack.append(note)
        default:
            return
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let containsValue = xmlStack.last as? ContainsValue, string.isEmpty == false else {
            return
        }
        guard let oldValue = containsValue.value, oldValue.isEmpty == false else {
            containsValue.value = string
            return
        }
        containsValue.value = oldValue + string
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        _ = xmlStack.popLast()
    }
}
