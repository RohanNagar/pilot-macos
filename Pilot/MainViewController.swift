//
//  MainViewController.swift
//  Pilot
//
//  Created by Rohan Nagar on 9/26/15.
//  Copyright © 2015 Sanction. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

  var platforms = [Platform]()

  @IBOutlet weak var fileCollectionView: NSCollectionView!

  override func viewDidLoad() {
    super.viewDidLoad()

    let layout = NSCollectionViewFlowLayout()
    layout.sectionInset = NSEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    layout.itemSize = CGSize(width: 90, height: 120)

    fileCollectionView.collectionViewLayout = layout
    fileCollectionView.registerNib(NSNib(nibNamed: "FileCollectionViewItem", bundle: nil), forItemWithIdentifier: "fileItem")
  }

  /// Sets up the list of platforms for the left-side platform table.
  func setupPlatforms() {
    let facebook = Platform(title: "Facebook", icon: nil)
    let twitter = Platform(title: "Twitter", icon: nil)
    let dropbox = Platform(title: "Dropbox", icon: nil)

    platforms = [facebook, twitter, dropbox]
  }

}

/// MARK: - NSTableViewDataSource
extension MainViewController: NSTableViewDataSource {

  /// Returns the number of rows that should be present in the TableView.
  func numberOfRowsInTableView(tableView: NSTableView) -> Int {
    return self.platforms.count
  }

  /// Returns the cell view for the requested column and row.
  func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {

    // Make a cell view
    if let cellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as? NSTableCellView {

      // If we're looking at the right column, set up the cell view
      if tableColumn!.identifier == "PlatformColumn" {
        let platform = platforms[row]
        cellView.imageView!.image = platform.icon
        cellView.textField!.stringValue = platform.name
        return cellView
      }

    }

    // Otherwise don't return a view
    return nil
  }

}

/// MARK: - NSTableViewDelegate
extension MainViewController: NSTableViewDelegate {

}

/// MARK: - NSCollectionViewDataSource
extension MainViewController: NSCollectionViewDataSource {

  func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }

  func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
    let item = collectionView.makeItemWithIdentifier("fileItem", forIndexPath: indexPath)

    return item
  }

}

/// MARK: - NSCollectionViewDelegateFlowLayout
extension MainViewController: NSCollectionViewDelegateFlowLayout {

}
