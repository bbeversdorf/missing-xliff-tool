//
//  FileSelectViewController+NSWindowDelegate.swift
//  MissingXliffTools
//
//  Created by brianbeversdorf on 11/11/17.
//  Copyright © 2017 brianbeversdorf. All rights reserved.
//

import Cocoa

extension FileSelectViewController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        // If it's the only window close it
        guard terminateAppOnClose == true else {
            return
        }
        NSApplication.shared.terminate(self)
    }
}
