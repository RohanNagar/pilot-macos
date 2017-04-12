//
//  CollectionViewController.swift
//  Pilot
//
//  Created by Nick Eckert on 8/16/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

import Cocoa

class CollectionViewController: NSViewController {

  @IBOutlet weak var collectionView: NSCollectionView!

  // This is the array of files to display to the user, this array will be indexed the same as it
  // will show to the user so you can re-order the array and reload the collection view to meet the
  // requirements for the sort drop down
  var content: [LocalFile] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let nib = NSNib(nibNamed: "FileCollectionViewItem", bundle: nil) else {
      return
    }

    collectionView.register(nib, forItemWithIdentifier: "fileItem")
  }

}

/// MARK: - NSCollectionViewDelegateFlowLayout
extension CollectionViewController: NSCollectionViewDelegateFlowLayout {}

/// MARK: - NSCollectionViewDataSource
extension CollectionViewController: NSCollectionViewDataSource {

  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return content.count
  }

  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let item = collectionView.makeItem(withIdentifier: "fileItem", for: indexPath)
    item.representedObject = content[indexPath.item]

    return item
  }

}
