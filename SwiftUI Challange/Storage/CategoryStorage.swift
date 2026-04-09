//
//  CategoryStorage.swift
//  SwiftUI Challange
//
//  Created by Johnson on 09/04/26.
//
import Foundation

struct CategoryStorage {
    
    private static let key = "categories_key"
    
    static func save(_ categories: [Category]) {
        do {
            let data = try JSONEncoder().encode(categories)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("❌ Failed to save:", error)
        }
    }
    
    static func load() -> [Category] {
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
