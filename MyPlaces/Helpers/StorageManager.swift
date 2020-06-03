//
//  StorageManager.swift
//  MyPlaces
//
//  Created by mac on 26.05.2020.
//  Copyright © 2020 Aleksandr Balabon. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
    
    static func deletePbject(_ place: Place) {
        try! realm.write {
            realm.delete(place)
        }
    }
}
