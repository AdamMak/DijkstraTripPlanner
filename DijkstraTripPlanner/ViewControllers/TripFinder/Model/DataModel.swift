//
//  DataModel.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 24/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import UIKit
import MapKit

struct DataModel: Codable {
    let connections: [Connections]
}

struct Connections: Codable {
    let from: String
    let to: String
    let price: Int
    let coordinates: Coordinates
}

struct Coordinates: Codable {
    let from: LongLat
    let to: LongLat
}

struct LongLat: Codable {
    let lat: Double
    let long: Double
}
