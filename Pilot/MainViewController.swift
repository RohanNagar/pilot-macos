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

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  /**
   * Sets up the list of platforms for the left-side platform table.
   */
  func setupPlatforms() {
    let facebook = Platform(title: "Facebook", icon: nil)
    let twitter = Platform(title: "Twitter", icon: nil)
    let dropbox = Platform(title: "Dropbox", icon: nil)
    
    platforms = [facebook, twitter, dropbox]
  }

}

/// MARK: - NSTableViewDataSource
extension MainViewController: NSTableViewDataSource {
  
  /**
   * Returns the number of rows that should be present in the TableView.
   */
  func numberOfRowsInTableView(tableView: NSTableView) -> Int {
    return self.platforms.count
  }
  
  /**
   * Returns the cell view for the requested column and row.
   */
  func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
    
    if tableColumn!.identifier == "PlatformColumn" {
      let platform = platforms[row]
      cellView.imageView!.image = platform.icon
      cellView.textField!.stringValue = platform.name
      return cellView
    }
    
    return cellView
  }
  
}

/// MARK: - NSTableViewDelegate
extension MainViewController: NSTableViewDelegate {
  
}
