//
//  CategoryStorage.swift
//  SwiftUI Challange
//
//  Created by Johnson on 09/04/26.
//
import Foundation

protocol CategoryStorageProtocol {
    func save(_ categories: [Category])
    func load() -> [Category]
}

struct CategoryStorage: CategoryStorageProtocol {
    
    private let key = "categories_key"
    
    func save(_ categories: [Category]) {
        do {
            let data = try JSONEncoder().encode(categories)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("❌ Failed to save:", error)
        }
    }
    
    func load() -> [Category] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([Category].self, from: data)
        } catch {
            print("❌ Failed to load:", error)
            return []
        }
    }
}
