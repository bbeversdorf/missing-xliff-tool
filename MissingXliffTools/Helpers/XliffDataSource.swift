//
//  XliffDatasource.swift
//  MissingXliffTools
//
//  Created by brianbeversdorf on 11/11/17.
//  Copyright © 2017 brianbeversdorf. All rights reserved.
//

import Foundation

struct XliffDataSource {
    static func buildXliff(xliffFilePath: String?, csvFileURLs: [URL]) -> [TableRowData] {
        guard let xliffFilePath = xliffFilePath else {
            return []
        }
        let xliff = XliffFileParser.parse(filePath: xliffFilePath)
        var data = xliff?.files.flatMap({ file in
            return file.body.transUnits.flatMap { TableRowData(file: file, transUnit: $0, dataTypes: [.xliff]) }
        }) ?? []
        guard let targetLanguage = xliff?.files.first?.targetLanguage, let csvFilePath = csvFileURLs.first(where: { $0.path.contains("\(targetLanguage).csv") })?.path else {
            return data
        }
        let csvXliff = CSVFileParser.parse(filePath: csvFilePath)
        csvXliff?.files.forEach { file in
            let newData = file.body.transUnits.flatMap { TableRowData(file: file, transUnit: $0, dataTypes: [.csv]) }
            data.append(contentsOf: newData)
        }
        return data
    }

    static func populateUntranslated(for dataSource: [TableRowData], using completeDatasource: [TableRowData]) -> [TableRowData] {
        // Find empty translation
        var emptyValues: [Int] = []
        for (index, element) in dataSource.enumerated() {
            guard element.transUnit.target?.value?.isEmpty != false else {
                continue
            }
            emptyValues.append(index)
        }
        guard emptyValues.isEmpty == false else {
            return []
        }
        emptyValues.forEach { index in
            guard let id = dataSource[index].transUnit.id, let source = dataSource[index].transUnit.source else {
                return
            }
            let newTarget = completeDatasource.first(where: { $0.transUnit.id == id && $0.transUnit.target?.value?.isEmpty == false })?.transUnit.target?.value
            if newTarget?.isEmpty == false {
                updateTarget(using: dataSource, at: index, with: newTarget)
            }
            let newTargetSource = completeDatasource.first(where: { $0.transUnit.source?.value == source.value && $0.transUnit.target?.value?.isEmpty == false })?.transUnit.target?.value
            if newTargetSource?.isEmpty == false {
                updateTarget(using: dataSource, at: index, with: newTarget)
            }
        }
        return dataSource
    }

    static internal func updateTarget(using dataSource: [TableRowData], at index: Int, with value: String?) {
        guard index >= 0 && index < dataSource.count else {
            return
        }
        if dataSource[index].transUnit.target == nil {
            dataSource[index].transUnit.target = Target()
        }
        dataSource[index].transUnit.target?.value = value
        dataSource[index].updateTargetText()
    }

    static func identifyInconsistencies(in currentDatasource: [TableRowData]) -> [TableRowData] {
        let xliffData = currentDatasource.filter { $0.dataTypes.contains(.xliff) }
        let csvData = currentDatasource.filter { $0.dataTypes.contains(.csv) }
        var data: [TableRowData] = []
        xliffData.forEach { dataset in
            if let similarData = csvData.first(where: { $0.transUnit.id == dataset.transUnit.id &&
                ($0.transUnit.source?.value != dataset.transUnit.source?.value ||
                    $0.transUnit.target?.value != dataset.transUnit.target?.value)
            }) {
                data.append(dataset)
                data.append(similarData)
            }
        }
        return data
    }
}
