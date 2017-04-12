//
//  PlatformService.swift
//  Pilot
//
//  Created by Nick Eckert on 7/18/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

import Cocoa
import FileKit

class PlatformService: NSObject {

  fileprivate let user: PilotUser!

  init(user: PilotUser) {
    self.user = user
  }

  func syncFacebook(_ facebookService: FacebookService) {
    facebookService.refreshCachedCloudContent({ cloudFiles in

      // Fetch the cachedLocalContent from facebookService
      let localFiles = facebookService.fetchCachedLocalContent()

      // TODO: Compare the arrays and check for a change before starting the comparison algorithm
      // TODO: Optimise this comparison for larger arrays

      // Check for cloudFiles not in the localFiles array. Downloaded them if this is the case
      for item in cloudFiles {
        if !localFiles.contains(where: {$0.name == item.name}) {
          // Create the DB entry and download the file upon completion! I'm so excited about this!
          DBController.sharedDBController.createFacebookFile(item, completion: { _ in
            facebookService.download(item, platformType: PlatformType.facebook, failure: { failedFile in
              // If the download fialed then obliterate the file >:)
              DBController.sharedDBController.deleteFacebookFileByName(failedFile.name)
            })
          })
        }
      }

      // Check for localFiles not in the cloudFiles array. Delete them if this is the case
      for item in localFiles {
        if !cloudFiles.contains(where: {$0.name == item.name}) {
          guard let itemStringPath = facebookService.preferences.getRootPath(service: .facebook) else {
            continue
          }

          // Remove the DB entry
          DBController.sharedDBController.deleteFacebookFileByName(item.name)

          // Remove the file from cachedLocalContent
          if let removeIndex = facebookService.cachedLocalContent.index(where: {$0.name == item.name}) {
            facebookService.cachedLocalContent.remove(at: removeIndex)

            let itemPath = Path(itemStringPath)
            let fileToDelete = File<NSDictionary>(path: itemPath)

            // Delete the file
            do {
              try fileToDelete.delete()
            } catch FileKitError.deleteFileFail(path: itemPath) {
              ErrorController.sharedErrorController.displayError("Unable to delete file at path \(itemStringPath)")
            } catch {
              print("There was an error trying to delete file at path \(itemStringPath)")
            }
          }
        }
      }
    })
  }

}
