//
//  Model.swift
//  xliff2csv
//
//  Created by brianbeversdorf on 10/26/17.
//  Copyright © 2017 brianbeversdorf. All rights reserved.
//

import Foundation

class Xliff {
    var files: [File] = []
    init() {}
}

class File {
    var original: String? //="Makani/Targets/Makani/WebServiceLogLabels.strings"
    var sourceLanguage: String? //="en"
    var dataType: String? //"plaintext"
    var targetLanguage: String?
    var header = Header()
    var body = Body()
    init(original: String?, sourceLanguage: String?, dataType: String?, targetLanguage: String?) {
        self.original = original
        self.sourceLanguage = sourceLanguage
        self.dataType = dataType
        self.targetLanguage = targetLanguage
    }

    func translatedPath() -> String? {
        guard let original = original,
            let _ = sourceLanguage,
            let targetLanguage = targetLanguage else {
                return nil
        }
        var translatedPath = original
        translatedPath = translatedPath.replacingOccurrences(of: "en.lproj", with: "\(targetLanguage).lproj")
        translatedPath = translatedPath.replacingOccurrences(of: "Base.lproj", with: "\(targetLanguage).lproj")
        translatedPath = translatedPath.replacingOccurrences(of: ".storyboard", with: ".strings")

        if translatedPath.contains("Info.plist") || translatedPath.contains("InfoPlist.strings") {
            translatedPath = translatedPath.replacingOccurrences(of: "Info.plist", with: "InfoPlist.strings")
        } else {
            translatedPath = translatedPath.replacingOccurrences(of: "Targets/Makani", with: "\(targetLanguage).lproj")
        }
        translatedPath = translatedPath.replacingOccurrences(of: "\(targetLanguage).lproj/\(targetLanguage).lproj", with: "Resources/\(targetLanguage).lproj")

        if translatedPath.contains("Labels.strings") && !translatedPath.contains("Localize") {
            translatedPath = translatedPath.replacingOccurrences(of: "Makani/Resources/", with: "Makani/Resources/Localize/")
        }
        return translatedPath
    }
}

class Header {
    var tool: Tool?
}

class Tool {
    var toolId: String? // = "com.apple.dt.xcode"
    var toolName: String? //="Xcode"
    var toolVersion: String? //="9.0.1"
    var buildNum: String? //="9A1004"
    init(toolId: String?, toolName: String?, toolVersion: String?, buildNum: String?) {
        self.toolId = toolId
        self.toolName = toolName
        self.toolVersion = toolVersion
        self.buildNum = buildNum
    }
}

class Body {
    var transUnits: [TransUnit] = []
    init() {}
}

class TransUnit {
    var id: String? // "Complete"
    var source: Source?
    var target: Target?
    var note: Note?
    init(id: String?) {
        self.id = id
    }

    func stringForStringsFile() -> String? {
        guard let id = id ?? source?.value,
            let target = target?.value else {
                return nil
        }
        guard let note = note?.value else {
            return "/* No comment provided */\n\"\(id)\" = \"\(target)\";\n\n"
        }
        return "/* \(note) */\n\"\(id)\" = \"\(target)\";\n\n"
    }
}

class Source: ContainsValue {
}

class Target: ContainsValue {
}

class Note: ContainsValue {
}

class ContainsValue {
    var value: String? // = "Web Service Log Status - Complete"
    init(value: String? = nil) {
        self.value = value
    }
}

