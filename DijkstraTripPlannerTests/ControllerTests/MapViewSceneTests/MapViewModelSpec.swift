//
//  MapViewModelSpec.swift
//  DijkstraTripPlannerTests
//
//  Created by Adam Makhfoudi on 28/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import DijkstraTripPlanner

class MapViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: MapViewModel!

        let nodes = [
            TripNode.init(name: "London", coordinates: LongLat(lat: 5, long: 5)),
            TripNode.init(name: "New York", coordinates: LongLat(lat: 5, long: 5)),
        ]

        beforeEach {
            let trip = CheapestTrip(nodes: nodes, price: 200)
            viewModel = MapViewModel(trip: trip, coordinator: nil)
        }

        describe("tripText") {
            var expectedText: String!

            beforeEach {
                expectedText = nodes.map { $0.name }.joined(separator: " -> ")
            }

            it("returns expected text") {
                expect(viewModel.tripText).to(equal(expectedText))
            }
        }

        describe("priceText") {
            let expectedText = "Price: £200"

            it("returns expected text") {
                expect(viewModel.tripPrice).to(equal(expectedText))
            }
        }

        describe("pins") {
            it("returns expected pins") {
                for index in 0..<nodes.count {
                    let result = viewModel.pins[index]
                    let match = nodes[index]
                    expect(result.title).to(equal(match.name))
                    expect(result.coordinate.latitude).to(equal(match.coordinates.lat))
                    expect(result.coordinate.longitude).to(equal(match.coordinates.long))
                }
            }
        }
    }
}
