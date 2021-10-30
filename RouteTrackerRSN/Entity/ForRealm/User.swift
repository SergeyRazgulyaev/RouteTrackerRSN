//
//  User.swift
//  RouteTrackerRSN
//
//  Created by Sergey Razgulyaev on 09.04.2021.
//

import Foundation
import RealmSwift

class User: Object, Decodable {
    @objc dynamic var login: String = ""
    @objc dynamic var password: String = ""
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case password = "password"
    }
    
    override class func primaryKey() -> String? {
        return "login"
    }
}
