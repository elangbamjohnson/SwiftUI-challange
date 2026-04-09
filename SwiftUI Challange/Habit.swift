//
//  Habit.swift
//  SwiftUI Challange
//
//  Created by Johnson on 07/04/26.
//

import Foundation

struct Habit : Identifiable, Codable{
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
}
