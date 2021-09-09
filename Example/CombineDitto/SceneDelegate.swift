//
//  SceneDelegate.swift
//  CombineDitto_Example
//
//  Created by Maximilian Alexander on 6/11/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: ContentView(viewModel: ViewModel()))
        self.window = window
        window.makeKeyAndVisible()
    }
}
