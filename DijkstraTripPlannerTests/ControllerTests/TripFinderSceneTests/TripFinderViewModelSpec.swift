//
//  TripFinderViewModelSpec.swift
//  DijkstraTripPlannerTests
//
//  Created by Adam Makhfoudi on 27/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import Combine
import Quick
import Nimble

@testable import DijkstraTripPlanner

class TripFinderViewModelSpec: QuickSpec {
    override func spec() {
        describe("validRoute") {
            var disposables: Set<AnyCancellable>!
            var viewModel: TripFinderViewModel!

            beforeEach {
                disposables = Set<AnyCancellable>()
            }

            context("given a valid route found") {
                var result: Bool?
                
                beforeEach {
                    let pathFinder = StubPathFinder(tripFound: true)
                    viewModel = TripFinderViewModel(pathFinder: pathFinder, coordinator: nil)

                    viewModel.validRoute.sink(receiveValue: { value in
                        result = value
                    }).store(in: &disposables)
                }
                
                it("returns true") {
                    expect(result).toEventually(equal(true))
                }
            }

            context("given no valid route found") {
                var result: Bool?

                beforeEach {
                    let pathFinder = StubPathFinder(tripFound: false)
                    viewModel = TripFinderViewModel(pathFinder: pathFinder, coordinator: nil)

                    viewModel.validRoute.sink(receiveValue: { value in
                        result = value
                    }).store(in: &disposables)
                }

                it("returns true") {
                    expect(result).toEventually(equal(false))
                }
            }
        }
    }
}
