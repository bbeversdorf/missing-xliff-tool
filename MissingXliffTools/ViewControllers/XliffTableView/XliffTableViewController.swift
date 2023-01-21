//
//  XliffTableViewController.swift
//  MissingXliffTools
//
//  Created by brianbeversdorf on 10/29/17.
//  Copyright © 2017 brianbeversdorf. All rights reserved.
//

import Cocoa

class XliffTableViewController: NSViewController {

    enum FilterFlags {
        case hidePrototype
        case hidePreviouslyTranslated
        case hideAccessibility
        case showInconsistencies
    }

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var tabCollectionView: NSCollectionView!
    @IBOutlet weak var hidePrototypeButton: NSButton!
    @IBOutlet weak var hidePreviouslyTranslatedButton: NSButton!
    @IBOutlet weak var hideAccessibilityLabelsButton: NSButton!
    @IBOutlet weak var showInconsistenciesButton: NSButton!

    var xliffFileURLs: [URL] = []
    var csvFileURLs: [URL] = []
    var projectDirectory: URL?
    var xliffFilePath: String?
    var csvFilePath: String?
    internal var dataSource: [TableRowData] = []
    internal var completeDataSource: [TableRowData] {
        return XliffDataSource.buildXliff(xliffFilePath: xliffFilePath, csvFileURLs: csvFileURLs)
    }
    internal var currentFilterFlags: [FilterFlags] {
        var filterFlags: [FilterFlags] = []
        if hidePrototypeButton.state == .on {
            filterFlags.append(.hidePrototype)
        }
        if hidePreviouslyTranslatedButton.state == .on {
            filterFlags.append(.hidePreviouslyTranslated)
        }
        if hideAccessibilityLabelsButton.state == .on {
            filterFlags.append(.hideAccessibility)
        }
        if showInconsistenciesButton.state == .on {
            filterFlags.append(.showInconsistencies)
        }
        return filterFlags
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDatasourceWithFilters()
        NotificationCenter.default.addObserver(self, selector: #selector(cellDidEndEditing(_:)), name: NSControl.textDidEndEditingNotification, object: nil)
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.delegate = self
    }

    @objc func cellDidEndEditing(_ notification: Notification) {
        guard let textField = notification.object as? NSTextField else {
            return
        }
        XliffDataSource.updateTarget(using: dataSource, at: tableView.selectedRow, with: textField.stringValue)
    }

    
}

// MARK: Copy
extension XliffTableViewController {
    func copySelectedRow() {
        let selectedRows = tableView.selectedRowIndexes
        var textToCopy = ""
        selectedRows.forEach { rowIndex in
            let row = dataSource[rowIndex]
            textToCopy += row.textForRow()
            textToCopy += "\n"
        }
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(textToCopy, forType: .string)
    }
    @IBAction func copy(_ sender: Any) {
        copySelectedRow()
    }
}

// MARK: IBActions
extension XliffTableViewController {
    @IBAction func filtersHaveChanged(_ sender: Any) {
        if sender as? NSButton == hidePreviouslyTranslatedButton && hidePreviouslyTranslatedButton.state == .on {
            showInconsistenciesButton.state = .off
        }
        if sender as? NSButton == showInconsistenciesButton && showInconsistenciesButton.state == .on {
            hidePreviouslyTranslatedButton.state = .off
        }
        updateDatasourceWithFilters(flags: currentFilterFlags)
    }
    @IBAction func populateUntranslated(_ sender: Any) {
        dataSource = XliffDataSource.populateUntranslated(for: dataSource, using: completeDataSource)
        tableView.reloadData()
    }
    @IBAction func updateStrings(_ sender: Any) {
        let completeDataSource = self.completeDataSource
        FileHandler.populateStringsFile(using: dataSource, comparingWith: completeDataSource, directory: projectDirectory)
    }

    @IBAction func exportXliff(_ sender: Any) {
        let alert = NSAlert()
        alert.addButton(withTitle: "Ok")
        alert.messageText = "This feature has not been implemented yet."
        alert.runModal()
    }

    @IBAction func menuSetAsPrototype(_ sender: Any) {
        print("You clicked Item 1 for row \(self.tableView.clickedRow)")
    }
}
