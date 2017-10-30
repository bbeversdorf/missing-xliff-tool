//
//  FileSelectViewController.swift
//  MissingXliffTools
//
//  Created by brianbeversdorf on 10/29/17.
//  Copyright © 2017 brianbeversdorf. All rights reserved.
//

import Cocoa

class FileSelectViewController: NSViewController {
    static let tableViewSegueIdentifier = NSStoryboardSegue.Identifier(rawValue: "tableViewSegue")

    private var xliffURLs: [URL] = []
    private var csvURLs: [URL] = []
    private var projectDirectoryURL: URL?

    internal var terminateAppOnClose = true
    @IBOutlet weak var xliffFileNameTextfield: NSTextField?
    @IBOutlet weak var csvFileNameTextfield: NSTextField?
    @IBOutlet weak var projectDirectoryNameTextfield: NSTextField?

    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.delegate = self
    }

    override func shouldPerformSegue(withIdentifier identifier: NSStoryboardSegue.Identifier, sender: Any?) -> Bool {
        return xliffFileNameTextfield?.stringValue.isEmpty == false
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        guard let vc = segue.destinationController as? XliffTableViewController else {
            return
        }
        vc.xliffFileURLs = xliffURLs.sorted(by: { $0.path < $1.path} )
        vc.xliffFilePath = xliffFileNameTextfield?.stringValue
        vc.csvFileURLs = csvURLs.sorted(by: { $0.path < $1.path} )
        if let urlPath = projectDirectoryNameTextfield?.stringValue,
            projectDirectoryURL == nil {
            vc.projectDirectory = URL(fileURLWithPath: urlPath)
        } else {
            vc.projectDirectory = projectDirectoryURL
        }
        terminateAppOnClose = false
        view.window?.close()
    }
}

// MARK: IBActions
extension FileSelectViewController {

    @IBAction func browseForXliffFiles(sender: AnyObject) {

        let dialog = NSOpenPanel();

        guard let result = dialog.selectXliff,
            let path = result.first?.path else {
                return
        }
        xliffFileNameTextfield?.stringValue = path
        xliffURLs = result
    }

    @IBAction func browseForCSVFiles(sender: AnyObject) {

        let dialog = NSOpenPanel();

        guard let result = dialog.selectCSV,
            let path = result.first?.path else {
                return
        }
        csvFileNameTextfield?.stringValue = path
        csvURLs = result
    }

    @IBAction func browseForProjectDirectory(sender: AnyObject) {

        let dialog = NSOpenPanel();

        guard let result = dialog.selectProjectDirectory else {
            return
        }
        projectDirectoryNameTextfield?.stringValue = result.path
        projectDirectoryURL = result
    }
}
