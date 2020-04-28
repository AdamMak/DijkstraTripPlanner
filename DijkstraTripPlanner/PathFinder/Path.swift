//
//  Path.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 26/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

class Path {
    public let cumulativePrice: Int
    public let node: Node
    public let previousPath: Path?

    init(to node: Node,
         via connection: NodeConnection? = nil,
         previousPath path: Path? = nil) {
        if
            let previousPath = path,
            let viaConnection = connection {
            self.cumulativePrice = viaConnection.price + previousPath.cumulativePrice
        } else {
            self.cumulativePrice = 0
        }

        self.node = node
        self.previousPath = path
    }

    var array: [Node] {
          var array: [Node] = [self.node]

          var iterativePath = self
          while let path = iterativePath.previousPath {
              array.append(path.node)

              iterativePath = path
          }

          return array
      }
}
