//
//  Node.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 24/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import Foundation

class Node {
    var visited = false
    var connections: [NodeConnection] = []
}

class NodeConnection {
    public let to: Node
    public let price: Int

    public init(to node: Node, price: Int) {
        self.to = node
        self.price = price
    }
}

class TripNode: Node {
    let name: String
    let coordinates: LongLat

    init(name: String,
         coordinates: LongLat) {
        self.name = name
        self.coordinates = coordinates
        super.init()
    }
}
