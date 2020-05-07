//
//  MapViewControllerSpec.swift
//  DijkstraTripPlannerTests
//
//  Created by Adam Makhfoudi on 27/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import DijkstraTripPlanner

class MapViewControllerSpec: QuickSpec {
    override func spec() {
        describe("Content") {
            var viewController: MapViewController!
            let nodes = [
                TripNode.init(name: "London", coordinates: LongLat(lat: 5, long: 5)),
                TripNode.init(name: "New York", coordinates: LongLat(lat: 5, long: 5)),
            ]

            beforeEach {
                let trip = CheapestTrip(nodes: nodes, price: 200)
                let viewModel = MapViewModel(trip: trip, coordinator: nil)
                viewController = MapViewController(viewModel: viewModel)
                UIApplication.shared.windows.first?.rootViewController = viewController
            }

            context("tripLabel") {
                var expectedText: String!

                beforeEach {
                    expectedText = nodes.map { $0.name }.joined(separator: " -> ")
                }

                it("sets trip label with expected content") {
                    expect(viewController.tripLabel.text).to(equal(expectedText))
                }
            }

            context("priceLabel") {
                let expectedText = "Price: £200"

                it("sets trip label with expected content") {
                    expect(viewController.priceLabel.text).to(equal(expectedText))
                }
            }

            context("annotations") {
                it("shows expected number of annotations") {
                    expect(viewController.mapView.annotations.count).toEventually(equal(2))
                }
            }

            context("overlays") {
                it("shows expected number of overlays") {
                    expect(viewController.mapView.overlays.count).toEventually(equal(1))
                }
            }
        }
    }
}
