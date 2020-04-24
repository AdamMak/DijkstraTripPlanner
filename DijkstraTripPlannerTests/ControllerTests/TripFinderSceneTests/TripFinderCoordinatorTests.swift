//
//  TripFinderCoordinatorTests.swift
//  DijkstraTripPlannerTests
//
//  Created by Adam Makhfoudi on 27/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import XCTest

@testable import DijkstraTripPlanner

class TripFinderCoordinatorTests: XCTestCase {
    var coordinator: TripFinderCoordinator!

    override func setUp() {
        let navigator = Navigator(navigationController: UINavigationController())
        coordinator = TripFinderCoordinator(navigatable: navigator)
        coordinator.start()
        UIApplication.shared.windows.first?.rootViewController = navigator.navigationController
    }

    override func tearDown() {

    }

    func testStart() {
        XCTAssertTrue(UIApplication.topViewController() is TripFinderViewController)
    }

    func testShowMapCoordinator() {
        let nodes = [
            TripNode.init(name: "London", coordinates: LongLat(lat: 5, long: 5)),
            TripNode.init(name: "New York", coordinates: LongLat(lat: 5, long: 5)),
        ]
        let trip = CheapestTrip(nodes: nodes, price: 200)
        coordinator.show(trip: trip)

        let exp = expectation(description: "Test after 0.5 seconds - wait for navigation")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.5)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(UIApplication.topViewController() is MapViewController)
        } else {
            XCTFail("Delay interrupted")
        }
    }
}
