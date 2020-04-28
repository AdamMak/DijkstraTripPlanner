//
//  TripFinderCoordinatorSpec.swift
//  DijkstraTripPlannerTests
//
//  Created by Adam Makhfoudi on 27/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import DijkstraTripPlanner

class TripFinderCoordinatorSpec: QuickSpec {
    override func spec() {
        describe("start") {
            var coordinator: TripFinderCoordinator!

            beforeEach {
                let navigator = Navigator(navigationController: UINavigationController())
                coordinator = TripFinderCoordinator(navigatable: navigator)
                coordinator.start()
                UIApplication.shared.windows.first?.rootViewController = navigator.navigationController
            }

            it("presents an instance of TripFinderViewController") {
                expect(UIApplication.topViewController()).toEventually(beAnInstanceOf(TripFinderViewController.self))
            }

            context("given show:trip is called") {
                beforeEach {
                    let nodes = [
                        TripNode.init(name: "London", coordinates: LongLat(lat: 5, long: 5)),
                        TripNode.init(name: "New York", coordinates: LongLat(lat: 5, long: 5)),
                    ]

                    let trip = CheapestTrip(nodes: nodes, price: 200)
                    coordinator.show(trip: trip)
                }

                it("shows MapViewController") {
                    expect(UIApplication.topViewController()).toEventually(beAnInstanceOf(MapViewController.self))
                }
            }
        }
    }
}
