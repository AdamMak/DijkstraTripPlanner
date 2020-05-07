//
//  PathFinderMonodirectionalTests.swift
//  DijkstraTripPlannerTests
//
//  Created by Adam Makhfoudi on 27/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import DijkstraTripPlanner

class PathFinderMonodirectionalTests: QuickSpec {
    override func spec() {
        describe("Given isBirectional is disabled") {
            var pathFinder: PathFinder!

            beforeEach {
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

                beforeEach {
                    result = pathFinder.cheapestTrip(origin: "New York", destination: "London")
                }

                it("returns no route found error") {
                    if case let .failure(error) = result {
                        expect(error as? PathFinderErrors).to(equal(PathFinderErrors.noRouteFound))
                    } else {
                        fail()
                    }
                }
            }
        }
    }
}
