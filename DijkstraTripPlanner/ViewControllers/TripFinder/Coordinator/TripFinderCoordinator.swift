//
//  TripFinderCoordinator.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 24/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import Foundation

class TripFinderCoordinator: Coordinator {
    override func start() {
        let viewModel = TripFinderViewModel(pathFinder: PathFinder(), coordinator: self)
        let viewController = TripFinderViewController(viewModel: viewModel)
        show(viewController)
    }

    func startMapCoordinator(trip: CheapestTrip) {
        let coordinator = MapCoordinator(presenter: presenter, trip: trip)
        coordinator.start()
    }
}

