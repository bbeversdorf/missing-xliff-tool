//
//  CollectionViewDatasource.swift
//  MissingXliffTools
//
//  Created by brianbeversdorf on 11/1/17.
//  Copyright © 2017 brianbeversdorf. All rights reserved.
//

import Cocoa
extension XliffTableViewController: NSCollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return xliffFileURLs.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {

        guard let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TabCollectionViewItem"), for: indexPath) as? TabCollectionViewItem else {
            return NSCollectionViewItem()
        }
        let shortenedPath = xliffFileURLs[indexPath.item].lastPathComponent
        item.label.stringValue = shortenedPath

        return item
    }

}

extension XliffTableViewController: NSCollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSZeroSize
    }
}

extension XliffTableViewController: NSCollectionViewDelegate {

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first,
            let item = collectionView.item(at: indexPath) as? TabCollectionViewItem else {
                return
        }
        item.highlightState = .forSelection
        xliffFilePath = xliffFileURLs[indexPath.item].path
        updateDatasourceWithFilters(flags: currentFilterFlags)
    }

    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first,
            let _ = collectionView.item(at: indexPath) as? TabCollectionViewItem else {
                return
        }
    }

}
