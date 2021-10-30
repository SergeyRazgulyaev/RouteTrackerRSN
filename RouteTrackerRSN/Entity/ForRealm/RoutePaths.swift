//
//  RoutePaths.swift
//  RouteTrackerRSN
//
//  Created by Sergey Razgulyaev on 06.04.2021.
//

import Foundation
import RealmSwift

class RoutePaths: Object, Decodable {
    @objc dynamic var currentPath: String = ""
    @objc dynamic var previousPath: String = ""
}
