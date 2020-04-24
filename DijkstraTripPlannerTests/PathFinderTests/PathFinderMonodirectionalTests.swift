//
//  PathFinderMonodirectionalTests.swift
//  DijkstraTripPlannerTests
//
//  Created by Adam Makhfoudi on 27/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import XCTest
@testable import DijkstraTripPlanner

class PathFinderMonodirectionalTests: XCTestCase {
    var pathFinder: PathFinder!

    override func setUp() {
        pathFinder = PathFinder(isBirectional: false)

        let fileURL = Bundle(for: type(of: self)).url(forResource: "connections", withExtension: "json")

        do {
            let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
            let data = content.data(using: .utf8)
            let dataModel = try data!.map(decodable: DataModel.self)
            pathFinder.setupNodes(connections: dataModel.connections)
        } catch {
            print(error)
        }
    }

    override func tearDown() {
        
    }

    func testSimpleRouteTrip() {
        let result = pathFinder.cheapestTrip(origin: "London", destination: "New York")

        switch result {
        case .success(let trip):
            XCTAssert(trip.nodes.count == 2)
        case .failure(let error):
            print(error)
        }
    }

    func testBidirectionalRouteTrip() {
        let result = pathFinder.cheapestTrip(origin: "New York", destination: "London")

        switch result {
        case .success(_):
            XCTFail("Should throw error as bidirectional is false")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }
}
