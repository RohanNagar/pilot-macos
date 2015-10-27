# Pilot (OS X)
[![Build Status](https://travis-ci.org/RohanNagar/pilot-osx.svg?branch=master)](https://travis-ci.org/RohanNagar/pilot-osx)
![Version](https://img.shields.io/badge/version-dev-7f8c8d.svg)
[![Twitter](https://img.shields.io/badge/twitter-%40RohanNagar22-00aced.svg)](http://twitter.com/RohanNagar22)

Pilot is a cloud-management application. Combine your files from Dropbox, Google Drive, Facebook, and more all in one location!

* [Running Locally](#running-locally)

## Running Locally
- Requirements
  - Xcode 7.0 (Swift 2.0)

First, fork this repo on GitHub. Then, clone your forked repo onto your machine.

```bash
$ git clone YOUR-FORK-URL
```

Open up the project in Xcode. Open the `Pilot.xcworkspace` file, *not* the `Pilot.xcproject` file. Press the play button at the top left of the Xcode window to build and then launch the application.

> *Note:* Currently, you need to be running [Thunder](https://github.com/RohanNagar/thunder) and [Lightning](https://github.com/RohanNagar/lightning) locally for the app to work correctly. Once the backend APIs are available over the internet, this will no longer be the case.
