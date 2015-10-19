//
//  PilotUserService.swift
//  Pilot
//
//  Created by Rohan Nagar on 10/18/15.
//  Copyright © 2015 Sanction. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON

class PilotUserService: NSObject {
  // Headers to use on HTTP requests to Thunder
  var headers: [String: String]
  
  // Endpoint to connect to lightning
  let endpoint = "http://localhost:8080/users"

  /* Default init */
  override init() {
    let user = "lightning"
    let password = "12345"
    
    let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
    let base64Credentials = credentialData.base64EncodedStringWithOptions([])
    
    headers = ["Authorization": "Basic \(base64Credentials)"]
  }
  
}
