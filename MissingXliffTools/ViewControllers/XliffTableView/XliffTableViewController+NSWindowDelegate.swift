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
        let mainStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("rootWindowControllerIdentifier")
        guard let fileSelectViewController = mainStoryboard.instantiateController(withIdentifier: identifier) as? NSWindowController else {
            return
        }
        fileSelectViewController.showWindow(nil)
    }
}
