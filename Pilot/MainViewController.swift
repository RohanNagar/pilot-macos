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

  @IBOutlet weak var tableView: NSTableView!

  @IBOutlet weak var iconImageView: NSImageView!

  // The user currently logged in
  var user: PilotUser?

  // Users preferences loaded from the loginViewController
  var preferences: Preferences?

  // FacebookService class optionally loaded from the loginViewController
  var facebookService: FacebookService?

  // Array of platforms present in the platform table
  var platforms = [Platform]()

  // Service classes used to sync platforms with cloud variant
  var platformService: PlatformService?

  // This is the array of files to display to the user, this array will be indexed the same as it
  // will show to the user so you can re-order the array and reload the colleciton view to meet the
  // requirnments for the sort drop down
  // NOTE: The zeroth element is the bound content for the collectionView.
  var content: [LocalFile] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    // Set the pilot logo for the view
    iconImageView.image = NSImage(named: "LoginIcon")

    // Set up the platform service
    self.platformService = PlatformService(user: user!)

    guard let nib = NSNib(nibNamed: "FileCollectionViewItem", bundle: nil) else {
      print("could not load collection view item") // Throw appropriate error later
      return
    }

    fileCollectionView.registerNib(nib, forItemWithIdentifier: "fileItem")
  }

  // Search the files in the collection view for the keywords sepcified
  @IBAction func search(sender: AnyObject) {

  }

  // Sync the files for the current platform with its online platform
  @IBAction func sync(sender: AnyObject) {
    let selection = platforms[tableView.selectedRow].type
      switch selection {
      case .Facebook:
        platformService!.syncFacebook(facebookService!)
      case .Twitter:
        print("Twitter")
      default:
        // Let the defualt slection be the all platform
        print("default selection")
      }
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

  func loadUserPreferences(preferences: Preferences) {
    self.preferences = preferences
  }

  func loadFacebookService(facebookService: FacebookService) {
    self.facebookService = facebookService
  }

  func loadUser(user: PilotUser) {
    self.user = user
  }

}

/// MARK: - NSTableViewDelegate
extension MainViewController: NSTableViewDelegate {

  func tableViewSelectionDidChange(notification: NSNotification) {
    let selection = platforms[tableView.selectedRow].type
    switch selection {
    case .Facebook:
      content = facebookService!.content
      fileCollectionView.reloadData()
    case .Twitter:
      print("Twitter")
    default:
      print("Default")
    }
  }

}

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
