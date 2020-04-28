//
//  MapCoordinatorSpec.swift
//  DijkstraTripPlannerTests
//
//  Created by Adam Makhfoudi on 27/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import DijkstraTripPlanner

class MapCoordinatorSpec: QuickSpec {
    override func spec() {
        describe("start") {
            var coordinator: MapCoordinator!

            beforeEach {
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

            it("presents an instance of MapViewController") {
                expect(UIApplication.topViewController()).toEventually(beAnInstanceOf(MapViewController.self))
            }
        }
    }
}
