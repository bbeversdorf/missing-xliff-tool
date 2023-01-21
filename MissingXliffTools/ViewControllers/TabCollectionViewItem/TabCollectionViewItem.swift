//
//  TabCollectionViewItem.swift
//  MissingXliffTools
//
//  Created by brianbeversdorf on 11/1/17.
//  Copyright © 2017 brianbeversdorf. All rights reserved.
//

import Cocoa

class TabCollectionViewItem: NSCollectionViewItem {
    override var isSelected: Bool {
        didSet {
            view.layer?.borderWidth = isSelected ? 1.0 : 0.0
            view.layer?.borderColor = isSelected ? NSColor.lightGray.cgColor : NSColor.clear.cgColor
            view.layer?.backgroundColor = isSelected ? NSColor.darkGray.cgColor : NSColor.clear.cgColor
        }
    }
    @IBOutlet weak var label: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer?.borderColor = NSColor.lightGray.cgColor
        view.layer?.borderWidth = 0.0
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        view.layer?.cornerRadius = 20
    }
}
