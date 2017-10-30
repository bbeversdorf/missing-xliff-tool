//
//  XliffTableCellView.swift
//  MissingXliffTools
//
//  Created by brianbeversdorf on 11/11/17.
//  Copyright © 2017 brianbeversdorf. All rights reserved.
//

import Cocoa

class XliffTableCellView: NSTableCellView {
    var model: TableCellModel? {
        didSet {
            guard let model = model else {
                return
            }
            textField?.stringValue = model.text
        }
    }
}
