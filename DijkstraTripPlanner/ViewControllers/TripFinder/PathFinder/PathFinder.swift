//
//  PathFinder.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 24/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

struct CheapestTrip {
    let nodes: [TripNode]
    let price: Int
}

// handle any errors
enum PathFinderErrors: Error {
    case noRouteFound
    case sameNode
    case noNodeFound
}

protocol PathFinderProtocol {
    func setupNodes(connections: [Connections])
    func cheapestTrip(origin: String, destination: String) -> Result<CheapestTrip, Error>
}

class PathFinder: PathFinderProtocol {
    private var nodes = [TripNode]()
    let isBirectional: Bool

    // setting this default to true
    // pass in false if want path finder to be mono-directional
    init(isBirectional: Bool = true) {
        self.isBirectional = isBirectional
    }

    func setupNodes(connections: [Connections]) {
        nodes = setupNodesAndConnections(connections: connections)
    }

    func cheapestTrip(origin: String, destination: String) -> Result<CheapestTrip, Error> {
        guard origin != destination else { return .failure(PathFinderErrors.sameNode) }

        nodes.forEach {
            $0.visited = false
        }

        guard let startNode = nodes.first(where: {$0.name == origin}) else { return .failure(PathFinderErrors.noNodeFound) }

        guard let endNode = nodes.first(where: {$0.name == destination}) else { return .failure(PathFinderErrors.noNodeFound) }

        guard let path = cheapestPath(source: startNode, destination: endNode) else {
            return .failure(PathFinderErrors.noRouteFound)
        }

        let routeNodes = path.array.reversed().compactMap({ $0 as? TripNode})

        let trip = CheapestTrip(nodes: routeNodes, price: path.cumulativePrice)
        return .success(trip)
    }

    private func cheapestPath(source: Node,
                              destination: Node) -> Path? {
        var frontier: [Path] = [Path(to: source)]

        while !frontier.isEmpty {
            let cheapestPathInFrontier = frontier.removeFirst()

            guard !cheapestPathInFrontier.node.visited else { continue }

            if cheapestPathInFrontier.node === destination {
                return cheapestPathInFrontier
            }

            cheapestPathInFrontier.node.visited = true

            for connection in cheapestPathInFrontier.node.connections where !connection.to.visited {
                frontier.append(Path(to: connection.to, via: connection, previousPath: cheapestPathInFrontier))
            }
        }
        return nil
    }

    private func setupNodesAndConnections(connections: [Connections]) -> [TripNode] {
        var nodes = [TripNode]()

        connections.forEach { connection in
            if(!nodes.map{$0.name}.contains(connection.from)) {
                nodes.append(TripNode(name: connection.from, coordinates: connection.coordinates.from))
            }

            if(!nodes.map{$0.name}.contains(connection.to)) {
                nodes.append(TripNode(name: connection.to, coordinates: connection.coordinates.to))
            }
        }

        for node in nodes {
            let matchingFromConnections = connections.filter{$0.from == node.name}

            for connection in matchingFromConnections {
                let nodesToAdd = nodes.filter{$0.name == connection.to}

                nodesToAdd.forEach {
                    let nodeConnection = NodeConnection(to: $0, price: connection.price)
                    node.connections.append(nodeConnection)
                }
            }

            // if bidirectional set to true, will be able to find nodes going either direction
            // for example if there is trip - London -> New York, if this is set to false
            // then will only be able to find a trip going London -> New York
            // however if set to true, then can also find trip going New York -> London
            if(isBirectional) {
                let matchingToConnections = connections.filter{$0.to == node.name}
                for connection in matchingToConnections {
                    let nodesToAdd = nodes.filter{$0.name == connection.from}
                    nodesToAdd.forEach {
                        let nodeConnection = NodeConnection(to: $0, price: connection.price)
                        node.connections.append(nodeConnection)
                    }
                }
            }
        }
        return nodes
    }
}
