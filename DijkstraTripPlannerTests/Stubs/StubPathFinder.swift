//
//  StubPathFinder.swift
//  DijkstraTripPlannerTests
//
//  Created by Adam Makhfoudi on 27/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

@testable import DijkstraTripPlanner

internal class StubPathFinder: PathFinderProtocol {
    let tripFound: Bool
    init(tripFound: Bool) {
        self.tripFound = tripFound
    }

    func cheapestTrip(origin: String, destination: String) -> Result<CheapestTrip, Error> {
        if tripFound {
            let nodes = [
                TripNode.init(name: "London", coordinates: LongLat(lat: 5, long: 5)),
                TripNode.init(name: "New York", coordinates: LongLat(lat: 5, long: 5)),
            ]
            return .success(CheapestTrip(nodes: nodes, price: 200))
        } else {
            return .failure(PathFinderErrors.noRouteFound)
        }
    }

    func setupNodes(connections: [Connections]) {

    }
}
