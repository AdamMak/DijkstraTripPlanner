//
//  TripFinderViewControllerSpec.swift
//  DijkstraTripPlannerTests
//
//  Created by Adam Makhfoudi on 27/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import DijkstraTripPlanner

private class SpyTripFinderViewControllerDelegate: TripFinderViewControllerDelegate {
    private(set) var showCalled = false

    func show(trip: CheapestTrip) {
        showCalled = true
    }
}

class TripFinderViewControllerSpec: QuickSpec {
    override func spec() {
        describe("on viewDidLoad") {
            var viewController: TripFinderViewController!
            var spy: SpyTripFinderViewControllerDelegate!

            beforeEach {
                spy = SpyTripFinderViewControllerDelegate()
                let viewModel = TripFinderViewModel(pathFinder: PathFinder())
                viewController = TripFinderViewController(viewModel: viewModel, delegate: spy)
                UIApplication.shared.windows.first?.rootViewController = viewController
            }


            it("has expected setup") {
                expect(viewController.activeTextField).toEventually(beNil())
                expect(viewController.suggestionsTableView.superview).toEventually(beNil())
                expect(viewController.showRouteButton.isEnabled).toEventually(beFalse())
            }

            context("given both origin and destination text entered") {
                beforeEach {
                    self.set(text: "London", for: viewController.originField)
                    self.set(text: "New York", for: viewController.destinationField)
                }

                it("enables the route button") {
                    expect(viewController.showRouteButton.isEnabled).toEventually(beTrue())
                }

                context("when one of the text fields is updated so there is no longer a valid route") {
                    beforeEach {
                        self.set(text: "test", for: viewController.originField)
                    }

                    it("disables the route button") {
                        expect(viewController.showRouteButton.isEnabled).toEventually(beFalse())
                    }
                }

                context("when route button is tapped") {
                    beforeEach {
                        expect(viewController.showRouteButton.isEnabled).toEventually(beTrue())
                        viewController.showRouteButton.sendActions(for: .touchUpInside)
                    }

                    it("sends a message to its delegate") {
                        expect(spy.showCalled).toEventually(beTrue())
                    }
                }
            }

            context("given origin text entered which nearly matches a location") {
                beforeEach {
                    self.set(text: "Lon", for: viewController.originField)
                }

                it("shows suggestions tableView") {
                    expect(viewController.suggestionsTableView.superview).toEventuallyNot(beNil())
                }

                context("when origin suggestion is tapped") {
                    beforeEach {
                        let indexPath = IndexPath(row: 0, section: 0)
                        viewController.suggestionsTableView.delegate?.tableView?(viewController.suggestionsTableView, didSelectRowAt: indexPath)
                    }

                    it("sets origin text") {
                        expect(viewController.originField.text).toEventually(equal("London"))
                    }

                    it("still shows the route button as disabled") {
                        expect(viewController.showRouteButton.isEnabled).toEventually(beFalse())
                    }
                }
            }

            context("when destination text entered which nearly matches a location") {
                beforeEach {
                    self.set(text: "New", for: viewController.destinationField)
                }

                it("shows suggestions tableView") {
                    expect(viewController.suggestionsTableView.superview).toEventuallyNot(beNil())
                }

                context("when destination suggestion is tapped") {
                    beforeEach {
                        let indexPath = IndexPath(row: 0, section: 0)
                        viewController.suggestionsTableView.delegate?.tableView?(viewController.suggestionsTableView, didSelectRowAt: indexPath)
                    }

                    it("sets origin text") {
                        expect(viewController.destinationField.text).toEventually(equal("New York"))
                    }

                    it("still shows the route button as disabled") {
                        expect(viewController.showRouteButton.isEnabled).toEventually(beFalse())
                    }
                }
            }
        }
    }

    private func set(text: String, for textField: UITextField) {
        textField.text = text
        textField.sendActions(for: .editingChanged)
    }
}
