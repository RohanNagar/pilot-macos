//
//  PlatformService.swift
//  Pilot
//
//  Created by Nick Eckert on 7/18/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

import Cocoa

class PlatformService: NSObject {

  private let user: PilotUser!

  init(user: PilotUser) {
    self.user = user
  }

  func syncFacebook(facebookService: FacebookService) {

    // Fetch the photos and videos from facebook and combine them into one conglomerate
    facebookService.getFacebookPhotos(user.username, password: user.password,
      completion: { returnPhotos in

        facebookService.getFacebookVideos(self.user.username, password: self.user.password,
          completion: { returnVideos in
            let cloudFiles = returnPhotos + returnVideos
            let expectedDownloads = self.compare(cloudFiles, second: facebookService.content)

            for item in expectedDownloads {
              facebookService.download(item.url, platformType: .Facebook, fileName: item.name)
            }
          },
          failure: {
            // Videos were not able to load
        })
      },
      failure: {
        // Photos were not able to load
      })
  }

  // Compare two arrays returning files from the first array without a match in the second array
  func compare(first: [CloudFile], second: [LocalFile]) -> [CloudFile] {
    var result: [CloudFile] = []

    for one in first {
      if !contains(second, item: one) {
        result.append(one)
      }
    }

    return result
  }

  func contains(array: [LocalFile], item: CloudFile) -> Bool {
    for one in array {
      if one.isEqual(item) {
        return true
      }
    }

    return false
  }

}
