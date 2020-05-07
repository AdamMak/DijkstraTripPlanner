//
//  MapViewModel.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 26/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import Foundation
import MapKit

class MapViewModel {
    private let trip: CheapestTrip
    private let coordinator: MapCoordinator?

    init(trip: CheapestTrip,
         coordinator: MapCoordinator?) {
        self.trip = trip
        self.coordinator = coordinator
    }

    var tripText: String {
        let text = trip.nodes.map { $0.name }.joined(separator: " -> ")
        return text
    }

    var tripPrice: String {
        let text = "Price: £\(trip.price)"
        return text
    }
    
    var pins: [CustomPin] {
        let pins = trip.nodes.map {
            CustomPin.init(pinTitle: $0.name,
                           location: CLLocationCoordinate2D(latitude: $0.coordinates.lat,
                                                            longitude: $0.coordinates.long))
        }
        return pins
    }
}
