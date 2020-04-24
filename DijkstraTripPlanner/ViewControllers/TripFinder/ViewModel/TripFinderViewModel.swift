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

    private(set) var trip = CurrentValueSubject<CheapestTrip?, Never>(nil)
    private(set) var suggestions = CurrentValueSubject<[String], Never>([])
    
    private let pathFinder: PathFinderProtocol
    private var connections: [Connections] = []
    private var disposables = Set<AnyCancellable>()

    var validRoute: AnyPublisher<Bool, Never> {
        return trip.map { $0 != nil }.eraseToAnyPublisher()
    }

    deinit {
        disposables.removeAll()
    }

    init(pathFinder: PathFinderProtocol) {
        self.pathFinder = pathFinder

        setUpConnections()

        let tripPublisher = Publishers
            .CombineLatest($origin.eraseToAnyPublisher(),
                           $destination.eraseToAnyPublisher())
            .map { [weak self] tuple in
                self?.pathFinder.cheapestTrip(origin: tuple.0, destination: tuple.1)
        }.receive(on: DispatchQueue.main)

        $origin.sink(receiveValue: { [weak self] text in
            self?.getSuggestions(from: text)
        }).store(in: &disposables)

        $destination.sink(receiveValue: { [weak self] text in
                       self?.getSuggestions(from: text)
            }).store(in: &disposables)

        tripPublisher.sink(receiveValue: { result in
            switch result {
            case .success(let trip):
                self.trip.value = trip
            default:
                self.trip.value = nil
            }
        }).store(in: &disposables)
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
}
