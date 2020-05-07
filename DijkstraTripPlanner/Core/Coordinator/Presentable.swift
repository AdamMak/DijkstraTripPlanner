//
//  Presentable.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 10/07/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import UIKit

/**
 Presentable is the entity that shows the view controller. If the presenter is a:
 - `UIViewController`: the view controller is presented
 - `UINavigationViewController`: the view controller is pushed, if the view controller is not a navigation controller
 - `UITabBarController`: the view controller is appended as a new tab
 - `UIWindow`: the view controller becomes the root
 */

protocol Presentable: class {
    func show(_ viewController: UIViewController)
}

extension UIViewController: Presentable {
    @objc func show(_ viewController: UIViewController) {
        if let tabBarController = self as? UITabBarController {
            show(viewController, from: tabBarController)
        } else if let navigationController = self as? UINavigationController,
            viewController is UINavigationController == false {
            show(viewController, from: navigationController)
        } else {
            present(viewController, animated: true)
        }
    }

    private func show(_ viewController: UIViewController, from tabBarController: UITabBarController) {
        var viewControllers = tabBarController.viewControllers ?? []
        viewControllers.append(viewController)
        tabBarController.viewControllers = viewControllers
    }

    private func show(_ viewController: UIViewController, from navigationController: UINavigationController) {
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}

extension UIWindow: Presentable {
    func show(_ viewController: UIViewController) {
        rootViewController = viewController
        makeKeyAndVisible()
    }
}
