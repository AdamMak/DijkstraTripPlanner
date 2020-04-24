//
//  TripFinderViewModelTests.swift
//  DijkstraTripPlannerTests
//
//  Created by Adam Makhfoudi on 27/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import XCTest
import Combine

@testable import DijkstraTripPlanner

class TripFinderViewModelTests: XCTestCase {

    var viewModel: TripFinderViewModel!
    private var disposables = Set<AnyCancellable>()

    override func setUp() { }

    override func tearDown() {
        disposables.removeAll()
    }

    func testingValidRoute() {
        var result = false

        viewModel = TripFinderViewModel(pathFinder: StubPathFinder(tripFound: true))
        viewModel.validRoute.sink(receiveValue:{ value in
            result = true
        }).store(in: &disposables)

        XCTAssertTrue(result)
    }

    func testingInValidRoute() {
        var result = false

        viewModel = TripFinderViewModel(pathFinder: StubPathFinder(tripFound: false))
        viewModel.validRoute.sink(receiveValue:{ value in
            result = value
        }).store(in: &disposables)

        XCTAssertFalse(result)
    }
}
