//
//  CustomPin.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 26/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import UIKit
import MapKit

class CustomPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?

    init(pinTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.coordinate = location
    }
}
