//
//  SceneDelegate.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 24/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: TripFinderCoordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        let navigator = Navigator(navigationController: UINavigationController())
        coordinator = TripFinderCoordinator(navigatable: navigator)
        coordinator.start()
        window.rootViewController = navigator.navigationController

        window.makeKeyAndVisible()
        self.window = window
    }
}

