//
//  MapCoordinator.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 26/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import Foundation

class MapCoordinator: Coordinator {
    private let trip: CheapestTrip

    required init(presenter: Presentable?, trip: CheapestTrip) {
        self.trip = trip

        super.init(presenter: presenter)
    }

    override func start() {
        let viewModel = MapViewModel(trip: trip, coordinator: self)
        let viewController = MapViewController(viewModel: viewModel)
        show(viewController)
    }
}
