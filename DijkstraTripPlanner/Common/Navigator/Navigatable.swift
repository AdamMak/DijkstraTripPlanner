//  
//  Navigatable.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 24/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import UIKit

protocol Navigatable: class {
    func push(_ viewController: UIViewController, isAnimated: Bool, onNavigateBack: (() -> Void)?)
    func present(_ viewController: UIViewController, isAnimated: Bool, onDismiss: (() -> Void)?)
    func dismiss(_ viewController: UIViewController, isAnimated: Bool)
    func popToRootViewController()
}
