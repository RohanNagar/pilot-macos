//
//  UploadViewController.swift
//  Pilot
//
//  Created by Nick Eckert on 8/17/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

import Cocoa

class UploadViewController: NSViewController {
  var delegate: UploadViewControllerDelegate?

  @IBOutlet weak var backButton: NSButtonCell!
  @IBOutlet weak var tableView: NSTableView!
  var files = [URL]()

  var user: PilotUser?
  var facebookService: FacebookService?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func selectFiles(_ sender: NSButton) {
    let panel = NSOpenPanel()

    panel.title = "Select Files to Upload"
    panel.allowsMultipleSelection = true
    panel.canChooseDirectories = false
    //panel.allowedFileTypes = ["jpg","png","pdf","pct", "bmp", "tiff"]

    panel.beginSheetModal(for: self.view.window!, completionHandler: { result in
      guard result == NSFileHandlingPanelOKButton else {
        return
      }

      let urls = panel.urls
      print("files selected = \(urls)")

      for url in urls {
        self.files.append(url)
      }

      self.tableView.reloadData()
    })
  }

  @IBAction func upload(_ sender: NSButton) {
    if let service = facebookService {
      service.upload(self.files, to: "\(PilotConfiguration.Lightning.endpoint)/facebook/publish", forUser: user!)
    }
  }

  @IBAction func dismiss(_ sender: AnyObject) {
    self.view.removeFromSuperview()

    if let del = delegate {
      del.returnFromUpload()
    }
  }

}

/// MARK: - NSTableViewDelegate
extension UploadViewController: NSTableViewDelegate {
  // Returns the cell view for the requested column and row.
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

    // Make a cell view
    if let cellView = tableView.make(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView {

      // If we're looking at the right column, set up the cell view
      if tableColumn!.identifier == "FileColumn" {
        let url = files[row]
        // cellView.imageView!.image = platform.icon
        cellView.textField!.stringValue = url.absoluteString
        return cellView
      }

    }

    // Otherwise don't return a view
    return nil
  }
}

/// MARK: - NSTableViewDataSource
extension UploadViewController: NSTableViewDataSource {

  /// Returns the number of rows that should be present in the TableView.
  func numberOfRows(in tableView: NSTableView) -> Int {
    return self.files.count
  }
  
}


protocol UploadViewControllerDelegate {
    func returnFromUpload()
}
