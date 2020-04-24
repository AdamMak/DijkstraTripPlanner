//
//  MapViewControllerTests.swift
//  DijkstraTripPlannerTests
//
//  Created by Adam Makhfoudi on 27/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import XCTest

@testable import DijkstraTripPlanner

class MapViewControllerTests: XCTestCase {
    private var viewController: MapViewController!
    private let nodes = [
        TripNode.init(name: "London", coordinates: LongLat(lat: 5, long: 5)),
        TripNode.init(name: "New York", coordinates: LongLat(lat: 5, long: 5)),
    ]

    override func setUp() {
        let trip = CheapestTrip(nodes: nodes, price: 200)
        let viewModel = MapViewModel(trip: trip)
        viewController = MapViewController(viewModel: viewModel)
        UIApplication.shared.windows.first?.rootViewController = viewController
    }

    override func tearDown() {
        
    }

    func testTripLabel() {
        let expectedText = nodes.map { $0.name }.joined(separator: " -> ")
        XCTAssertEqual(viewController.tripLabel.text, expectedText)
    }

    func testPriceLabel() {
        let expectedPrice = "Price: £200"
        XCTAssertEqual(viewController.priceLabel.text, expectedPrice)
    }

    func testAnnotations() {
        XCTAssertEqual(viewController.mapView.annotations.count, 2)
    }

    func testOverlays() {
        XCTAssertEqual(viewController.mapView.overlays.count, 1)
    }
}
