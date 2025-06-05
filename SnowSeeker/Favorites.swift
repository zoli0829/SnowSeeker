//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Zoltan Vegh on 04/06/2025.
//

import SwiftUI

@Observable
class Favorites {
    private var resorts: Set<String>
    private let key = "Favorites"
    
    init() {
        // load our data
        if let savedResorts = UserDefaults.standard.object(forKey: key) as? [String] {
            resorts = Set(savedResorts)
        } else {
            resorts = []
        }
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        let resortsArray = Array(resorts).sorted()
        UserDefaults.standard.set(resortsArray, forKey: key)
    }
}
