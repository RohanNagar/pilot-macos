//
//  PilotUser.swift
//  Pilot
//
//  Created by Rohan Nagar on 10/18/15.
//  Copyright © 2015 Sanction. All rights reserved.
//

import Cocoa

class PilotUser: NSObject {
  var email: String
  var password: String
  var facebookAccessToken: String
  var twitterAccessToken: String
  var twitterAccessSecret: String

  init(email: String, password: String, facebookAccessToken: String, twitterAccessToken: String, twitterAccessSecret: String) {
    self.email = email
    self.password = password
    self.facebookAccessToken = facebookAccessToken
    self.twitterAccessToken = twitterAccessToken
    self.twitterAccessSecret = twitterAccessSecret
  }

  override func isEqual(_ object: Any?) -> Bool {
    if let obj = object as? PilotUser {
      return self.email == obj.email
    }

    return false
  }

  override var description: String {
    return "PilotUser{email=\(email), password=\(password), facebookAccessToken=\(facebookAccessToken), twitterAccessToken=\(twitterAccessToken), twitterAccessSecret=\(twitterAccessSecret)}"
  }

}
