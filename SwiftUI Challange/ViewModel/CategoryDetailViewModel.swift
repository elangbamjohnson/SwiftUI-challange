// SwiftUI Challange/ViewModel/CategoryDetailViewModel.swift
import Foundation
import Combine
import SwiftUI

class CategoryDetailViewModel: ObservableObject {
    @Published var category: Category
    @Published var newItemTitle: String = "" // For the text field in the UI

    init(category: Category) {
        self.category = category
    }

    func addItem() {
        guard !newItemTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newItem = Item(id: UUID(), title: newItemTitle, isCompleted: false)
        withAnimation {
            category.items.insert(newItem, at: 0)
        }
        newItemTitle = "" // Clear the text field after adding
    }

    func deleteItem(at offsets: IndexSet) {
        withAnimation {
            category.items.remove(atOffsets: offsets)
        }
    }

    func toggleItemCompletion(itemIndex: Int) {
        guard category.items.indices.contains(itemIndex) else { return }
        category.items[itemIndex].isCompleted.toggle()
    }
}
