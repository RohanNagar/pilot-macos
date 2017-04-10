//
//  PilotColors.swift
//  Pilot
//
//  Created by Rohan Nagar on 7/15/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

import Cocoa

class PilotColors {
  static let PilotBlue = NSColor.fromRGB(red: 114.0, green: 192.0, blue: 228.0)
  static let PilotBrownBackground = NSColor.fromRGB(red: 242.0, green: 242.0, blue: 242.0)
  static let PilotBrownText = NSColor.fromRGB(red: 173.0, green: 173.0, blue: 173.0)
  static let ErrorRed = NSColor.fromRGB(red: 242, green: 71, blue: 15)
  static let White = NSColor.fromRGB(red: 255, green: 255, blue: 255)
}

extension NSColor {

  // Returns color instance from RGB values (0-255)
  static func fromRGB(red: Double, green: Double, blue: Double, alpha: Double = 100.0) -> NSColor {
    let rgbRed = CGFloat(red/255)
    let rgbGreen = CGFloat(green/255)
    let rgbBlue = CGFloat(blue/255)
    let rgbAlpha = CGFloat(alpha/100)

    return NSColor(red: rgbRed, green: rgbGreen, blue: rgbBlue, alpha: rgbAlpha)
  }

}
