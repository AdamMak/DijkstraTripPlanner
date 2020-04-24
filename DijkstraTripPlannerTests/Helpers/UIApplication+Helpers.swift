//
//  UIApplication+Helpers.swift
//  DijkstraTripPlannerTests
//
//  Created by Adam Makhfoudi on 27/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import UIKit

@testable import DijkstraTripPlanner

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {

        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }

        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

    class func getVisibleController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController?  {
        if let navigationController = controller as? UINavigationController {
            return getVisibleController(controller: navigationController.viewControllers.last)
        }
        return controller
    }
}
