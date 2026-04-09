//
//  Habit.swift
//  SwiftUI Challange
//
//  Created by Johnson on 07/04/26.
//

import Foundation

struct Habit : Identifiable{
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
}
