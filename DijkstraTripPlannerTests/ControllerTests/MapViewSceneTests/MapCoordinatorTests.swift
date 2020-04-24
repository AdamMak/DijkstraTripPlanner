//
//  MapCoordinatorTests.swift
//  DijkstraTripPlannerTests
//
//  Created by Adam Makhfoudi on 27/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import Foundation

import XCTest

@testable import DijkstraTripPlanner

class MapCoordinatorTests: XCTestCase {
    var coordinator: MapCoordinator!

    override func setUp() {
        let navigator = Navigator(navigationController: UINavigationController())
        let nodes = [
            TripNode.init(name: "London", coordinates: LongLat(lat: 5, long: 5)),
            TripNode.init(name: "New York", coordinates: LongLat(lat: 5, long: 5)),
        ]
        let trip = CheapestTrip(nodes: nodes, price: 200)

        coordinator = MapCoordinator(navigatable: navigator, trip: trip)
        coordinator.start()
        UIApplication.shared.windows.first?.rootViewController = navigator.navigationController
    }

    override func tearDown() {

    }

    func testStart() {
        XCTAssertTrue(UIApplication.topViewController() is MapViewController)
    }
}
