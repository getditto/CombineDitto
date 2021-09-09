//
//  AppDelegate.swift
//  CombineDitto
//
//  Created by 2183729 on 06/11/2021.
//  Copyright (c) 2021 2183729. All rights reserved.
//

import UIKit
import DittoSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var ditto: Ditto!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let identity = DittoIdentity.development(appName: "live.ditto.combine-example")
        Self.ditto = Ditto(identity: identity)

        return true
    }

    // read license token:
    func readLicenseToken() -> String {
        let path = Bundle.main.path(forResource: "license_token", ofType: "txt") // file path for file "data.txt"
        let string = try! String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        return string
    }

    // UISceneDelegate

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // The name must match the one in the Info.plist
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }


}

