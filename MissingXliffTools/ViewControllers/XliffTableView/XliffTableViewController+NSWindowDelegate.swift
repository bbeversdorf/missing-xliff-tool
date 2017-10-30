//
//  XliffTableViewController+NSWindowDelegate.swift
//  MissingXliffTools
//
//  Created by brianbeversdorf on 11/11/17.
//  Copyright © 2017 brianbeversdorf. All rights reserved.
//

import Cocoa

extension XliffTableViewController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        // If we close the window prompt for FileSelection
        let mainStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        guard let fileSelectViewController = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "rootWindowControllerIdentifier")) as? NSWindowController else {
            return
        }
        fileSelectViewController.showWindow(nil)
    }
}
