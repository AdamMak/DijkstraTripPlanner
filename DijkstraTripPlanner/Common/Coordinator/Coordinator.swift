//  
//  Coordinator.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 24/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import UIKit

enum PresentationType {
    case push
    case present
}

protocol Coordinator: class {
    func start()
    var navigatable: Navigatable? { get }

    var childCoordinators: [Coordinator] { get set }
    var didFinish: (() -> Void)? { get set }
}

extension Coordinator {
    func setUpCoordinator(_ coordinator: Coordinator) {
        coordinator.didFinish = { [weak self] in
            guard let strongSelf = self else {
                return
            }

            strongSelf.childCoordinators.removeLast()
        }

        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func navigate(viewController: UIViewController, presentationType: PresentationType) {
        switch presentationType {
        case .present:
            navigatable?.present(viewController, isAnimated: true, onDismiss: didFinish)
        case .push:
            navigatable?.push(viewController, isAnimated: true, onNavigateBack: didFinish)
        }
    }
}

