//  
//  UITableView+Helpers.swift
//  DijkstraTripPlanner
//
//  Created by Adam Makhfoudi on 24/04/2020.
//  Copyright © 2020 Adam Makhfoudi. All rights reserved.
//

import UIKit

extension UITableView {
    func registerTableCell<T: UITableViewCell>(cell: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.identifier)
    }
}
