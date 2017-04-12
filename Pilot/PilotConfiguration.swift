//
//  PilotConfiguration.swift
//  Pilot
//
//  Created by Rohan Nagar on 4/12/17.
//  Copyright © 2017 Sanction. All rights reserved.
//

import Cocoa

struct PilotConfiguration {
  struct Thunder {
    static let endpoint = "http://thunder.nickeckert.com"
    static let userKey = "lightning"
    static let userSecret = "secret"
  }

  struct Lightning {
    static let endpoint = "http://lightning.nickeckert.com"
    static let userKey = "application"
    static let userSecret = "secret"
  }
}
