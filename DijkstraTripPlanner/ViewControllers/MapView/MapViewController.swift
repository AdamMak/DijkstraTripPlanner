//  
//  MapViewController.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 26/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet private(set) var mapView: MKMapView!
    @IBOutlet private(set) var tripLabel: UILabel!
    @IBOutlet private(set) var priceLabel: UILabel!

    private let viewModel: MapViewModel

    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: MapViewController.identifier, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Trip Information"

        mapView.delegate = self

        tripLabel.text = viewModel.tripText
        priceLabel.text = viewModel.tripPrice

        setUpMapRoute(pins: viewModel.pins)
    }

    private func setUpMapRoute(pins: [CustomPin]) {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)

        pins.forEach {
            mapView.addAnnotation($0)
        }

        let polyline = MKPolyline.init(coordinates: pins.map{$0.coordinate}, count: pins.count)
        mapView.addOverlay(polyline)
    }
}

// MARK: MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)

        if overlay is MKPolyline {
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
        }

        return polylineRenderer
    }

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        self.mapView.showAnnotations(mapView.annotations, animated: true)
    }
}
