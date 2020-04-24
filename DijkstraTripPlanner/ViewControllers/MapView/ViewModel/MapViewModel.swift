//
//  MapViewModel.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 26/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import Foundation

class MapViewModel {
    private let trip: CheapestTrip

    init(trip: CheapestTrip) {
        self.trip = trip
    }

    var tripText: String {
        let text = trip.nodes.map { $0.name }.joined(separator: " -> ")
        return text
    }

    var tripPrice: String {
        let text = "Price: £\(trip.price)"
        return text
    }

    var nodes: [TripNode] {
        return trip.nodes
    }
}
