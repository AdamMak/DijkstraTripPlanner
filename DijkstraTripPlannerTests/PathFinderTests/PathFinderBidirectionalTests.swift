//
//  PathFinderBidirectionalTests.swift
//  DijkstraTripPlannerTests
//
//  Created by Adam Makhfoudi on 27/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import DijkstraTripPlanner

class PathFinderBidirectionalTests: QuickSpec {
    override func spec() {
        describe("Given isBirectional is enabled") {
            var pathFinder: PathFinder!

            beforeEach {
                pathFinder = PathFinder(isBirectional: true)

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

            context("when a trip that requires monodirectional searching is entered") {
                var result: Result<CheapestTrip, Error>!
                let expectedNodes = 2

                beforeEach {
                    result = pathFinder.cheapestTrip(origin: "London", destination: "New York")
                }

                it("returns a trip successfully") {
                    if case let .success(trip) = result {
                        expect(trip.nodes.count).to(equal(expectedNodes))
                    } else {
                        fail()
                    }
                }
            }

            context("when a trip that requires bidirectional searching is entered") {
                var result: Result<CheapestTrip, Error>!
                let expectedNodes = 2

                beforeEach {
                    result = pathFinder.cheapestTrip(origin: "New York", destination: "London")
                }

                it("returns a trip successfully") {
                    if case let .success(trip) = result {
                        expect(trip.nodes.count).to(equal(expectedNodes))
                    } else {
                        fail()
                    }
                }
            }

            context("when an trip is entered that requires multiple nodes") {
                var result: Result<CheapestTrip, Error>!
                let expectedNodes = 3

                beforeEach {
                    result = pathFinder.cheapestTrip(origin: "Tokyo", destination: "New York")
                }

                it("returns a trip successfully") {
                    if case let .success(trip) = result {
                        expect(trip.nodes.count).to(equal(expectedNodes))
                    } else {
                        fail()
                    }
                }
            }

            context("when the origin and destination entered is the same") {
                var result: Result<CheapestTrip, Error>!

                beforeEach {
                    result = pathFinder.cheapestTrip(origin: "London", destination: "London")
                }

                it("returns a noNodeFound error") {
                    if case let .failure(error) = result {
                        expect(error as? PathFinderErrors).to(equal(PathFinderErrors.sameNode))
                    } else {
                        fail()
                    }
                }
            }

            context("when an invalid destination is entered") {
                var result: Result<CheapestTrip, Error>!

                beforeEach {
                    result = pathFinder.cheapestTrip(origin: "London", destination: "Germany")
                }

                it("returns a noNodeFound error") {
                    if case let .failure(error) = result {
                        expect(error as? PathFinderErrors).to(equal(PathFinderErrors.noNodeFound))
                    } else {
                        fail()
                    }
                }
            }

            context("when an invalid origin destination is entered") {
                var result: Result<CheapestTrip, Error>!

                beforeEach {
                    result = pathFinder.cheapestTrip(origin: "Germany", destination: "London")
                }

                it("returns a noNodeFound error") {
                    if case let .failure(error) = result {
                        expect(error as? PathFinderErrors).to(equal(PathFinderErrors.noNodeFound))
                    } else {
                        fail()
                    }
                }
            }
        }
    }
}
