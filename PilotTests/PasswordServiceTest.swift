//
//  PasswordServiceTest.swift
//  Pilot
//
//  Created by Rohan Nagar on 10/18/15.
//  Copyright © 2015 Sanction. All rights reserved.
//

import XCTest
import Nimble
@testable import Pilot

class PasswordServiceTest: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  /* PasswordHash Tests */
  func testHashSamePassword() {
    let firstHash = PasswordService.hashPassword("Password")
    let secondHash = PasswordService.hashPassword("Password")

    expect(firstHash).to(equal(secondHash))
  }

  func testHashDifferentPassword() {
    let firstHash = PasswordService.hashPassword("FirstPassword")
    let secondHash = PasswordService.hashPassword("SecondPassword")

    expect(firstHash).toNot(equal(secondHash))
  }
  
}
