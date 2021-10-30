//
//  RealmManager.swift
//  RouteTrackerRSN
//
//  Created by Sergey Razgulyaev on 06.04.2021.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let instance = RealmManager()
    
    private init?(){
        
        let configuration = Realm.Configuration(schemaVersion: 1, deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: configuration) else { return nil }
        self.realm = realm
        print(realm.configuration.fileURL ?? "")
    }
    
    private let realm: Realm
    
    func add <T: Object> (object: T) throws {
        try realm.write {
            realm.add(object)
        }
    }
    
    func add <T: Object> (objects: [T]) throws {
        try realm.write {
            realm.add(objects, update: .all)
        }
    }
    
    func getObjects <T: Object> () -> Results<T> {
        return realm.objects(T.self)
    }
    
    func delete <T: Object> (object: T) throws {
        try realm.write {
            realm.delete(object)
        }
    }
    
    func deleteAll() throws {
        try realm.write {
            realm.deleteAll()
        }
    }
    
    func deleteUser(user: User) throws {
            try realm.write {
                realm.delete(realm.objects(User.self).filter("login=%@", user.login))
        }
    }
    
    func deleteAllRoutePaths() throws {
            try realm.write {
                realm.delete(realm.objects(RoutePaths.self))
        }
    }
}
