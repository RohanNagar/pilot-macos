//
//  MainViewController.swift
//  Pilot
//
//  Created by Rohan Nagar on 9/26/15.
//  Copyright © 2015 Sanction. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

  @IBOutlet weak var fileCollectionView: NSCollectionView!

  @IBOutlet weak var iconImageView: NSImageView!

  var preferences: Preferences?

  // let fileService = FileService()

  var platforms = [Platform]()

  // This is the array of files to display to the user, this array will be indexed the same as it
  // will show to the user so you can re-order the array and reload the colleciton view to meet the
  // requirnments for the sort drop down
  var content: [AnyObject] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    loadFacebookPhotos()

    iconImageView.image = NSImage(named: "LoginIcon")

    guard let nib = NSNib(nibNamed: "FileCollectionViewItem", bundle: nil) else {
      print("could not load collection view item") // Throw appropriate error later
      return
    }

    fileCollectionView.registerNib(nib, forItemWithIdentifier: "fileItem")
  }

  // Search the files in the collection view for the keywords sepcified
  @IBAction func search(sender: AnyObject) {

  }

  // Sync the files for the current platform with it's online platform
  @IBAction func sync(sender: AnyObject) {

  }

  // Upload files to the current platform
  @IBAction func upload(sender: AnyObject) {

  }

  // Add a new platform to the left side table
  @IBAction func add(sender: AnyObject) {

  }

  // Sort the files in the collection view by a specific enum (Not yet implemented)
  @IBAction func sort(sender: AnyObject) {

  }

  // Add a platform to the left side table
  func addPlatform(platform: Platform) {
    self.platforms.append(platform)
  }

  func setUserPreferences(preferences: Preferences) {
    self.preferences = preferences
  }

  func loadFacebookPhotos() {
    content = FileLoader.getFilesFromPath("/Users/nickeckert/pilot/Testy/facebook")
  }

}

/// MARK: - NSTableViewDelegate
extension MainViewController: NSTableViewDelegate {}

/// MARK: - NSTableViewDataSource
extension MainViewController: NSTableViewDataSource {

  /// Returns the number of rows that should be present in the TableView.
  func numberOfRowsInTableView(tableView: NSTableView) -> Int {
    return self.platforms.count
  }

  // Returns the cell view for the requested column and row.
  func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {

    // Make a cell view
    if let cellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as? NSTableCellView {

      // If we're looking at the right column, set up the cell view
      if tableColumn!.identifier == "PlatformColumn" {
        let platform = platforms[row]
        // cellView.imageView!.image = platform.icon
        cellView.textField!.stringValue = platform.name
        return cellView
      }

    }

    // Otherwise don't return a view
    return nil
  }

}

/// MARK: - NSCollectionViewDelegateFlowLayout
extension MainViewController: NSCollectionViewDelegateFlowLayout {}

/// MARK: - NSCollectionViewDataSource
extension MainViewController: NSCollectionViewDataSource {

  func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return content.count
  }

  func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
    let item = collectionView.makeItemWithIdentifier("fileItem", forIndexPath: indexPath)
    item.representedObject = content[indexPath.item]
    return item
  }

}
