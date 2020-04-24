//
//  TripFinderCoordinator.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 24/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import Foundation

class TripFinderCoordinator: Coordinator {
    var didFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    var navigatable: Navigatable?

    required init(navigatable: Navigatable?) {
        self.navigatable = navigatable
    }

    func start() {
        let viewModel = TripFinderViewModel(pathFinder: PathFinder())
        let viewController = TripFinderViewController(viewModel: viewModel, delegate: self)
        navigate(viewController: viewController, presentationType: .push)
    }

    private func startMapCoordinator(trip: CheapestTrip) {
        let coordinator = MapCoordinator(navigatable: navigatable, trip: trip)
        setUpCoordinator(coordinator)
    }
}

extension TripFinderCoordinator: TripFinderViewControllerDelegate {
    func show(trip: CheapestTrip) {
        startMapCoordinator(trip: trip)
    }
}
