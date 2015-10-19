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

  /*
   * Returns a hashed version of the given String.
   *
   * Parameters:
   *    password: The String to hash.
   */
  static func hashPassword(password: String) -> String {
    return password.md5()
  }
  
  /*
   * Checks the validity of a password attempt.
   *
   * Parameters:
   *    attempt: The hashed password String that the user supplied.
   *    correct: The correct hashed password String.
   */
  static func checkValidity(attempt: String, correct: String) -> Bool {
    return attempt == correct ? true : false
  }
}
