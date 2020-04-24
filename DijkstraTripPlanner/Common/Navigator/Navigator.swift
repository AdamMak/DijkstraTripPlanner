//  
//  Navigator.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 24/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import UIKit

class Navigator: NSObject {
    private(set) var navigationController: UINavigationController
    private var finishClosures: [UIViewController: (() -> Void)] = [:]

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.view.backgroundColor = .clear

        super.init()

        self.navigationController.delegate = self
    }
}

extension Navigator: Navigatable {
    func push(_ viewController: UIViewController, isAnimated: Bool, onNavigateBack closure: (() -> Void)?) {
        if let closure = closure {
            finishClosures.updateValue(closure, forKey: viewController)
        }

        navigationController.pushViewController(viewController, animated:isAnimated)
    }

    func present(_ viewController: UIViewController, isAnimated: Bool, onDismiss closure: (() -> Void)?) {
        if let closure = closure {
            finishClosures.updateValue(closure, forKey: viewController)
        }

        navigationController.present(viewController, animated: isAnimated)
    }

    func dismiss(_ viewController: UIViewController, isAnimated: Bool) {
        viewController.dismiss(animated: true, completion: nil)

        executeClosure(viewController)
    }

    func popToRootViewController() {
        finishClosures.forEach {
            executeClosure($0.key)
        }

        navigationController.popToRootViewController(animated: false)
    }

    private func executeClosure(_ viewController: UIViewController) {
        guard let closure = finishClosures.removeValue(forKey: viewController) else { return }

        closure()
    }
}

extension Navigator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(previousController) else {
                return
        }

        executeClosure(previousController)
    }
}


