//
//  Habit.swift
//  SwiftUI Challange
//
//  Created by Johnson on 07/04/26.
//

import Foundation

struct Item : Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
}

