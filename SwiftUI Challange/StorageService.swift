//
//  StorageService.swift
//  SwiftUI Challange
//
//  Created by Johnson on 09/04/26.
//
import UIKit

struct HabitStorage {
    private static let key = "habits_key"
    
    static func save(_ habits: [Habit]) {
        do {
            let data = try JSONEncoder().encode(habits)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("❌ Failed to save habits:", error)
        }
        
    }
    
    static func load() -> [Habit] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([Habit].self, from: data)
        } catch {
            print("❌ Failed to load habits:", error)
            return[]
        }
    }
}
