//
//  TripFinderViewControllerTests.swift
//  DijkstraTripPlannerTests
//
//  Created by Adam Makhfoudi on 27/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import XCTest
@testable import DijkstraTripPlanner

private class SpyTripFinderViewControllerDelegate: TripFinderViewControllerDelegate {
    private(set) var showCalled = false

    func show(trip: CheapestTrip) {
        showCalled = true
    }
}

class TripFinderViewControllerTests: XCTestCase {
    private var viewController: TripFinderViewController!
    private var spy: SpyTripFinderViewControllerDelegate!

    override func setUp() {
        super.setUp()

        spy = SpyTripFinderViewControllerDelegate()
        let pathFinder = StubPathFinder(tripFound: true)
        let viewModel = TripFinderViewModel(pathFinder: pathFinder)
        viewController = TripFinderViewController(viewModel: viewModel, delegate: spy)
        UIApplication.shared.windows.first?.rootViewController  = viewController
    }

    override func tearDown() {
        super.tearDown()


    }

    func testOnLoad() {
        XCTAssertEqual(viewController.activeTextField, nil)
        XCTAssertEqual(viewController.suggestionsTableView.superview, nil)
        XCTAssertFalse(viewController.showRouteButton.isEnabled)
    }

    func testSuggestionsTableViewShows() {
        viewController.originField.text = "Lon"
        viewController.originField.sendActions(for: .editingChanged)
        XCTAssert(viewController.suggestionsTableView.superview != nil)
    }

    func testSuggestionsTableViewSelectSetsOriginField() {
        set(field: viewController.originField, with: "Lon")
        XCTAssertEqual(viewController.originField.text, "London")
    }

    func testSuggestionsTableViewSelectSetsDestinationField() {
        set(field: viewController.destinationField, with: "New")
        XCTAssertEqual(viewController.destinationField.text, "New York")
    }

    func testSettingOriginAndDestinationEnablesShowRouteButton() {
        setBothTextFields()

        let exp = expectation(description: "Test after 0.5 seconds - need to wait for event")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.5)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(viewController.showRouteButton.isEnabled)
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testDelegateIsCalled() {
        setBothTextFields()

        let exp = expectation(description: "Test after 0.5 seconds - need to wait for event")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.5)
        if result == XCTWaiter.Result.timedOut {
            viewController.showRouteButton.sendActions(for: .touchUpInside)
            XCTAssertEqual(spy.showCalled, true)
        } else {
            XCTFail("Delay interrupted")
        }
    }

    // MARK: Private functions

    private func set(field: UITextField, with text: String) {
        field.text = text
        field.sendActions(for: .editingChanged)
        let indexPath = IndexPath(row: 0, section: 0)
        viewController.suggestionsTableView.delegate?.tableView?(viewController.suggestionsTableView, didSelectRowAt: indexPath)
    }

    private func setBothTextFields() {
        set(field: viewController.originField, with: "Lon")
        set(field: viewController.destinationField, with: "New")
    }
}
