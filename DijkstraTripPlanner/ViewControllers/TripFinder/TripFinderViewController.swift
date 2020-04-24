//  
//  TripFinderViewController.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 24/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import UIKit
import Combine

protocol TripFinderViewControllerDelegate: class {
    func show(trip: CheapestTrip)
}

class TripFinderViewController: UIViewController {
    @IBOutlet private(set) var originField: UITextField!
    @IBOutlet private(set) var destinationField: UITextField!
    @IBOutlet private(set) var showRouteButton: UIButton!

    private var disposables = Set<AnyCancellable>()
    private let viewModel: TripFinderViewModel
    private weak var delegate: TripFinderViewControllerDelegate?
    private(set) var activeTextField: UITextField?

    private(set) lazy var suggestionsTableView: UITableView = {
        let frame = view.frame
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height / 4), style: .plain)
        tableView.registerTableCell(cell: UITableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    init(viewModel: TripFinderViewModel, delegate: TripFinderViewControllerDelegate? = nil) {
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: TripFinderViewController.identifier, bundle: nil)
    }

    deinit {
        disposables.removeAll()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Trip Finder"

        viewModel.validRoute
            .assign(to: \.isEnabled, on: showRouteButton)
            .store(in: &disposables)
        viewModel.suggestions.sink(receiveValue: { [weak self] suggestions in
            guard let strongSelf = self, let textField = strongSelf.activeTextField else {
                return
            }

            strongSelf.setupSuggestionsTableView(suggestions: suggestions, textField: textField)
        }).store(in: &disposables)
    }

    private func showErrorView() {
        let alertController = UIAlertController(title: "Error", message: "Error parsing JSON", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        alertController.show(alertController, sender: nil)
    }

    private func setupSuggestionsTableView(suggestions: [String],
                                           textField: UITextField) {
        if suggestionsTableView.superview != nil {
            suggestionsTableView.removeFromSuperview()
        }

        guard let text = textField.text,
            text.isEmpty == false,
            suggestions.count > 0 else {
                return
        }

        let textFrame = textField.frame
        suggestionsTableView.frame.origin.y = textFrame.origin.y + 30
        suggestionsTableView.reloadData()
        self.view.addSubview(suggestionsTableView)
    }

    @IBAction private func originDidChange(_ sender: UITextField) {
        activeTextField = sender
        viewModel.origin = sender.text ?? ""
    }

    @IBAction private func destinationDidChange(_ sender: UITextField) {
        activeTextField = sender
        viewModel.destination = sender.text ?? ""
    }

    @IBAction private func showRoute() {
        guard let trip = viewModel.trip.value else {
            return
        }
        
        delegate?.show(trip: trip)
    }
}

// MARK: UITableViewDataSource

extension TripFinderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.suggestions.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier) else {
            return UITableViewCell()
        }

        let suggestion = viewModel.suggestions.value[indexPath.row]
        cell.textLabel?.text = suggestion

        return cell
    }
}

// MARK: UITableViewDelegate

extension TripFinderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let suggestion = viewModel.suggestions.value[indexPath.row]
        activeTextField?.text = suggestion
        activeTextField?.sendActions(for: .editingChanged)
        activeTextField?.resignFirstResponder()
        suggestionsTableView.removeFromSuperview()
    }
}
