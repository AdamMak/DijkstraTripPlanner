//  
//  UIView+Helpers.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 24/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import UIKit

protocol UIViewIdentifiable {
    static var identifier: String { get }
}

extension UIViewController: UIViewIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIView : UIViewIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
