//
//  TableRowModel.swift
//  MissingXliffTools
//
//  Created by brianbeversdorf on 11/11/17.
//  Copyright © 2017 brianbeversdorf. All rights reserved.
//

import Cocoa

enum TableIdentifier: String {
    case file
    case id
    case source
    case target
    case note

    init?(columnId: String) {
        let rawValue = columnId.replacingOccurrences(of: "Column", with: "", options: .literal, range: nil)
        self.init(rawValue: rawValue)
    }

    private var column: String {
        return rawValue+"Column"
    }

    private var cell: String {
        return rawValue+"Cell"
    }

    var userInterfaceItemIdentifier: NSUserInterfaceItemIdentifier {
        return NSUserInterfaceItemIdentifier(rawValue: cell)
    }

    var indexSet: IndexSet {
        return IndexSet(integer: index)
    }

    var index: Int {
        switch self {
        case .file:
            return 0
        case .id:
            return 1
        case .source:
            return 2
        case .target:
            return 3
        case .note:
            return 4
        }
    }

    var sortDescriptor: NSSortDescriptor {
        return NSSortDescriptor(key: rawValue, ascending: true)
    }
}

class TableRowData {

    enum DatasourceType {
        case xliff
        case csv
    }

    var file: File
    var transUnit: TransUnit
    var dataTypes: [DatasourceType]
    let cells: [TableCellModel]
    var updatedForString: Bool = false

    init(file: File, transUnit: TransUnit, dataTypes: [DatasourceType] = []) {
        self.file = file
        self.transUnit = transUnit
        self.dataTypes = dataTypes
        var cells: [TableCellModel] = []
        let fileIdentifier = TableIdentifier.file
        let idIdentifier = TableIdentifier.id
        let sourceIdentifier = TableIdentifier.source
        let targetIdentifier = TableIdentifier.target
        let noteIdentifier = TableIdentifier.note
        cells.append(TableRowData.buildCell(at: fileIdentifier, file: file, transUnit: transUnit))
        cells.append(TableRowData.buildCell(at: idIdentifier, file: file, transUnit: transUnit))
        cells.append(TableRowData.buildCell(at: sourceIdentifier, file: file, transUnit: transUnit))
        cells.append(TableRowData.buildCell(at: targetIdentifier, file: file, transUnit: transUnit))
        cells.append(TableRowData.buildCell(at: noteIdentifier, file: file, transUnit: transUnit))
        self.cells = cells
    }

    static func buildCell(at tableIdentifier: TableIdentifier, file: File, transUnit: TransUnit) -> TableCellModel {
        var text: String?
        switch tableIdentifier {
        case .file:
            text = file.original
        case .id:
            text = transUnit.id
        case .source:
            text = transUnit.source?.value
        case .target:
            text = transUnit.target?.value
        case .note:
            text = transUnit.note?.value
        }
        return TableCellModel(tableIdentifier: tableIdentifier, text: text?.escaped ?? "")
    }

    func updateTargetText() {
        let cell = cells[TableIdentifier.target.index]
        cell.text = transUnit.target?.value ?? ""
    }

    func textForRow(delimiter: String = "\t") -> String {
        let text = cells.reduce("", { $0 + $1.text + delimiter })
        return text
    }
}

class TableCellModel {
    let tableIdentifier: TableIdentifier
    var text: String
    init(tableIdentifier: TableIdentifier, text: String) {
        self.tableIdentifier = tableIdentifier
        self.text = text
    }
}
