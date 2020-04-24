//
//  MapCoordinator.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 26/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import Foundation

class MapCoordinator: Coordinator {
    var didFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    var navigatable: Navigatable?
    private let trip: CheapestTrip

    required init(navigatable: Navigatable?, trip: CheapestTrip) {
        self.navigatable = navigatable
        self.trip = trip
    }

    func start() {
        let viewModel = MapViewModel(trip: trip)
        let viewController = MapViewController(viewModel: viewModel)
        navigate(viewController: viewController, presentationType: .push)
    }
}
