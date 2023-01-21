//
//  NSOpenPanel+Extension.swift
//  MissingXliffTools
//
//  Created by brianbeversdorf on 11/11/17.
//  Copyright © 2017 brianbeversdorf. All rights reserved.
//

import Cocoa

extension NSOpenPanel {
    var selectXliff: [URL]? {
        title = "Select Xliff Files"
        allowsMultipleSelection = true
        canChooseDirectories = true
        canChooseFiles = true
        canCreateDirectories = false
        allowedFileTypes = ["xliff"]
        return runModal() == .OK ? urls : nil
    }
    var selectCSV: [URL]? {
        title = "Select CSV Files"
        allowsMultipleSelection = true
        canChooseDirectories = false
        canChooseFiles = true
        canCreateDirectories = false
        allowedFileTypes = ["csv"]
        return runModal() == .OK ? urls : nil
    }
    var selectProjectDirectory: URL? {
        title = "Select Project Directory"
        allowsMultipleSelection = false
        canChooseDirectories = true
        canChooseFiles = false
        canCreateDirectories = false
        allowedFileTypes = []
        return runModal() == .OK ? urls.first : nil
    }
}
