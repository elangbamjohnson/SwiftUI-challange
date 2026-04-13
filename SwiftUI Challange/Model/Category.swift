//
//  Category.swift
//  SwiftUI Challange
//
//  Created by Johnson on 09/04/26.
//
import Foundation

struct Category: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var items: [Item]
    var iconName: String = "list.bullet"
    var colorHex: String = "#007AFF"
}
