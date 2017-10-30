//
//  XliffTableViewController+NSTableView.swift
//  MissingXliffTools
//
//  Created by brianbeversdorf on 11/11/17.
//  Copyright © 2017 brianbeversdorf. All rights reserved.
//

import Cocoa

extension XliffTableViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let columnId = tableColumn?.identifier.rawValue,
            let tableIdentifier = TableIdentifier(columnId: columnId) else {
                return nil
        }
        tableColumn?.sortDescriptorPrototype = tableIdentifier.sortDescriptor

        guard let cellView = tableView.makeView(withIdentifier: tableIdentifier.userInterfaceItemIdentifier, owner: nil) as? XliffTableCellView else {
            return nil
        }
        cellView.model = dataSource[row].cells[tableIdentifier.index]
        return cellView
    }

    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        dataSource = sort(source: dataSource, oldDescriptors: oldDescriptors)
        tableView.reloadData()
    }

    internal func updateDatasourceWithFilters(flags: [FilterFlags] = []) {
        let xliff = XliffDataSource.buildXliff(xliffFilePath: xliffFilePath, csvFileURLs: csvFileURLs)
        dataSource = sort(source: xliff)
        if flags.contains(.hidePrototype) {
            dataSource = dataSource.filter { $0.transUnit.note?.value?.contains("\"prototype\";") != true }
        }

        if flags.contains(.hideAccessibility) {
            dataSource = dataSource.filter { $0.transUnit.id?.contains(".accessibilityLabel") != true }
        }

        if flags.contains(.hidePreviouslyTranslated) {
            dataSource = dataSource.filter { $0.transUnit.target?.value?.isEmpty != false }
        }

        if flags.contains(.showInconsistencies) {
            dataSource = XliffDataSource.identifyInconsistencies(in: dataSource)
        }
        tableView.reloadData()
    }

    private func sort(source: [TableRowData], oldDescriptors: [NSSortDescriptor] = []) -> [TableRowData] {
        guard let sortDescriptor = tableView.sortDescriptors.first?.key, let tableIdentifier = TableIdentifier(rawValue: sortDescriptor) else {
            return source
        }
        guard sortDescriptor != oldDescriptors.first?.key || (sortDescriptor == oldDescriptors.first?.key && tableView.sortDescriptors.first?.ascending == false) else {
            tableView.sortDescriptors = []
            updateDatasourceWithFilters(flags: currentFilterFlags)
            return source
        }
        var data = source
        switch tableIdentifier {
        case .file:
            data = data.sorted { $0.file.original ?? "" < $1.file.original ?? ""}
        case .id:
            data = data.sorted { $0.transUnit.id ?? "" < $1.transUnit.id ?? ""}
        case .source:
            data = data.sorted { $0.transUnit.source?.value ?? "" < $1.transUnit.source?.value ?? ""}
        case .target:
            data = data.sorted { $0.transUnit.target?.value ?? "" < $1.transUnit.target?.value ?? ""}
        case .note:
            data = data.sorted { $0.transUnit.note?.value ?? "" < $1.transUnit.note?.value ?? ""}
        }
        if tableView.sortDescriptors.first?.ascending == false {
            data = data.reversed()
        }
        return data
    }
}

extension XliffTableViewController: NSTableViewDelegate {

}
