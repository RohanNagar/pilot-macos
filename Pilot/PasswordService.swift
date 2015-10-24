//
//  PasswordService.swift
//  Pilot
//
//  Created by Rohan Nagar on 10/18/15.
//  Copyright © 2015 Sanction. All rights reserved.
//

import Cocoa
import CryptoSwift

class PasswordService: NSObject {

  /**
   * Returns a hashed version of the given String.
   *
   * - parameters:
   *    - password: The String to hash.
   */
  static func hashPassword(password: String) -> String {
    return password.md5()
  }
  
}
