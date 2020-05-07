//  
//  TripFinderViewModel.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 24/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import Foundation
import Combine

class TripFinderViewModel {
    @Published var origin: String = ""
    @Published var destination: String = ""
    @Published var trip: CheapestTrip?
    private(set) var suggestions = CurrentValueSubject<[String], Never>([])
    
    private let pathFinder: PathFinderProtocol
    private var connections: [Connections] = []
    private var cancellables = Set<AnyCancellable>()
    private let coordinator: TripFinderCoordinator?

    var validRoute: AnyPublisher<Bool, Never> {
        return $trip.map { $0 != nil }.eraseToAnyPublisher()
    }

    deinit {
        cancellables.removeAll()
    }

    init(pathFinder: PathFinderProtocol,
         coordinator: TripFinderCoordinator?) {
        self.pathFinder = pathFinder
        self.coordinator = coordinator

        setUpConnections()

        Publishers
            .CombineLatest($origin.eraseToAnyPublisher(),
                           $destination.eraseToAnyPublisher())
            .map { [weak self] tuple in
                self?.pathFinder.cheapestTrip(origin: tuple.0, destination: tuple.1)
        }.map { result -> CheapestTrip? in
            if case let .success(trip) = result {
                return trip
            }

            return nil
        }.assign(to: \.trip, on: self).store(in: &cancellables)

        $origin.sink(receiveValue: { [weak self] text in
            self?.getSuggestions(from: text)
        }).store(in: &cancellables)

        $destination.sink(receiveValue: { [weak self] text in
            self?.getSuggestions(from: text)
        }).store(in: &cancellables)
    }

    private func setUpConnections() {
        let fileURL = Bundle.main.url(forResource: "connections",
                                              withExtension: "json")
        do {
            let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
            let data = content.data(using: .utf8)
            guard let dataModel = try data?.map(decodable: DataModel.self) else { return }

            let connections = dataModel.connections
            pathFinder.setupNodes(connections: connections)
            self.connections = connections
        } catch {
            fatalError("Error parsing local JSON")
        }
    }

    private func getSuggestions(from text: String) {
        let allConnections = Array(Set(connections.map { $0.from } + connections.map { $0.to }))
        let suggestions = findClosestMatches(text: text, suggestions: allConnections)
        self.suggestions.value = suggestions
    }

    private func findClosestMatches(text: String, suggestions: [String]) -> [String] {
        guard text.isEmpty == false else { return [] }

        let matches = suggestions.filter {
            $0.lowercased().hasPrefix(text.lowercased())
        }
        
        return (matches.count > 0) ? matches : []
    }

    func showTrip() {
        guard let trip = trip else {
            return
        }

        coordinator?.startMapCoordinator(trip: trip)
    }
}
