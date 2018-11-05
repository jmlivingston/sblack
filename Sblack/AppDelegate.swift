//
//  AppDelegate.swift
//  Sblack
//
//  Created by Francesco Di Lorenzo on 04/02/2018.
//  Copyright © 2018 Francesco Di Lorenzo. All rights reserved.
//

import Cocoa
import Sparkle

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        SUUpdater.shared().automaticallyChecksForUpdates = true
        
//        let url = URL(fileURLWithPath: "/Applications/Slack.app")
//        SlackPatcher.applySlackBlackTheme(at: url)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func showHelp(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: Constants.helpURL)!)
    }

}

