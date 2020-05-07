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
            var navigationController: UINavigationController!

            beforeEach {
                navigationController = UINavigationController()
                coordinator = TripFinderCoordinator(presenter: navigationController)
                coordinator.start()
                UIApplication.shared.windows.first?.rootViewController = navigationController
            }

            it("presents an instance of TripFinderViewController") {
                expect(navigationController.viewControllers.last).toEventually(beAnInstanceOf(TripFinderViewController.self))
            }

            context("given show:trip is called") {
                beforeEach {
                    let nodes = [
                        TripNode.init(name: "London", coordinates: LongLat(lat: 5, long: 5)),
                        TripNode.init(name: "New York", coordinates: LongLat(lat: 5, long: 5)),
                    ]

                    let trip = CheapestTrip(nodes: nodes, price: 200)
                    coordinator.startMapCoordinator(trip: trip)
                }

                it("shows MapViewController") {
                    expect(navigationController.viewControllers.last).toEventually(beAnInstanceOf(MapViewController.self))
                }
            }
        }
    }
}
