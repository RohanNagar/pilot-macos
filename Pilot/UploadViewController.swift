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

    override func viewDidLoad() {
        super.viewDidLoad()
}

  @IBAction func dismiss(sender: AnyObject) {
    self.view.removeFromSuperview()
    
    if let del = delegate {
        del.returnFromUpload()
    }
  }

}

protocol UploadViewControllerDelegate {
    func returnFromUpload()
}
