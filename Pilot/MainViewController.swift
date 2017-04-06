//
//  MainViewController.swift
//  Pilot
//
//  Created by Rohan Nagar on 9/26/15.
//  Copyright © 2015 Sanction. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController, UploadViewControllerDelegate {

  @IBOutlet weak var tableView: NSTableView!

  @IBOutlet weak var errorMessage: NSTextField!

  @IBOutlet weak var uploadButton: NSButton!

  @IBOutlet weak var headerTitle: NSTextField!
  
  // This view holds the various switchable views such as uploadView and collectionView
  @IBOutlet weak var customView: NSView!

  var collectionViewController: CollectionViewController!

  var uploadViewController: UploadViewController!

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

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.wantsLayer = true
    
    // Set up the platform service
    self.platformService = PlatformService(user: user!)

    // Create the uploadView to be used later on
    uploadViewController = UploadViewController(nibName: "UploadViewController", bundle: nil)

    uploadViewController.view.frame = customView.frame
    uploadViewController.delegate = self

    // Create a collectionViewConrtoller to be used with the custom view
    collectionViewController = CollectionViewController(nibName: "CollectionViewController", bundle: nil)

    collectionViewController.view.frame = customView.frame

    // Add the collectionView as the first view in the contentView
    customView.addSubview(collectionViewController.view)

    // collectionViewController.view.frame = contentView.bounds
    collectionViewController.view.bindFrameToSuperviewBounds()
  }
  
  override func awakeFromNib() {
    if self.view.layer != nil {
      let color: CGColor = PilotColors.White.cgColor
      self.view.layer?.backgroundColor = color
    }
  }
  
  override func viewDidAppear() {
    self.view.window!.backgroundColor = PilotColors.White

    self.view.window!.titleVisibility = NSWindowTitleVisibility.hidden
    self.view.window!.titlebarAppearsTransparent = true
    self.view.window!.isMovableByWindowBackground = false
  }
  
  // Search the files in the collection view for the keywords sepcified
  @IBAction func search(_ sender: AnyObject) {
    
  }

  // Sync the files for the current platform with its online platform
  @IBAction func sync(_ sender: AnyObject) {
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
  @IBAction func upload(_ sender: AnyObject) {
    collectionViewController.view.isHidden = true
    customView.addSubview(uploadViewController.view)

    uploadViewController.view.bindFrameToSuperviewBounds()
  }
    
    func returnFromUpload() {
        collectionViewController.view.isHidden = false
    }

  // Add a new platform to the left side table
  @IBAction func add(_ sender: AnyObject) {

  }

  // Add a platform to the left side table
  func addPlatform(_ platform: Platform) {
    self.platforms.append(platform)
  }

  func loadUserPreferences(_ preferences: Preferences) {
    self.preferences = preferences
  }

  func loadFacebookService(_ facebookService: FacebookService) {
    self.facebookService = facebookService
  }

  func loadUser(_ user: PilotUser) {
    self.user = user
  }

}

/// MARK: - NSTableViewDelegate
extension MainViewController: NSTableViewDelegate {

  func tableViewSelectionDidChange(_ notification: Notification) {
    // Do nothing if selected a non-existant cell
    if tableView.selectedRow == -1 {
        return
    }

    let selection = platforms[tableView.selectedRow].type
    switch selection {
    case .Facebook:
      headerTitle.stringValue = "Facebook"
      collectionViewController.content = facebookService!.fetchCachedLocalContent()
      collectionViewController.collectionView.reloadData()
    case .Twitter:
      headerTitle.stringValue = "Twitter"
      print("Twitter Pressed")
    default:
      print("Default Switch")
    }
  }

}

/// MARK: - NSTableViewDataSource
extension MainViewController: NSTableViewDataSource {

  /// Returns the number of rows that should be present in the TableView.
  func numberOfRows(in tableView: NSTableView) -> Int {
    return self.platforms.count
  }

  // Returns the cell view for the requested column and row.
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

    // Make a cell view
    if let cellView = tableView.make(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView {

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

extension NSImage {

  static func swatchWithColor(_ color: NSColor, size: NSSize) -> NSImage {
    let image = NSImage(size: size)
    image.lockFocus()
    color.drawSwatch(in: NSMakeRect(0, 0, size.width, size.height))
    image.unlockFocus()
    return image
  }

}
