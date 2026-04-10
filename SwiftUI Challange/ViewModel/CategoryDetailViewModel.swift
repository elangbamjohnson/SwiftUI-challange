// SwiftUI Challange/ViewModel/CategoryDetailViewModel.swift
import Foundation
import Combine
import SwiftUI

class CategoryDetailViewModel: ObservableObject {
    @Published var category: Category
    @Published var newItemTitle: String = "" // For the text field in the UI
    private let onCategoryChanged: (Category) -> Void // Callback to notify parent ViewModel

    init(category: Category, onCategoryChanged: @escaping (Category) -> Void) {
        self.category = category
        self.onCategoryChanged = onCategoryChanged
    }

    func addItem() {
        guard !newItemTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newItem = Item(id: UUID(), title: newItemTitle, isCompleted: false)
        category.items.insert(newItem, at: 0)
        newItemTitle = "" // Clear the text field after adding
        saveChanges()
    }

    func deleteItem(at offsets: IndexSet) {
        category.items.remove(atOffsets: offsets)
        saveChanges()
    }

    func toggleItemCompletion(itemIndex: Int) {
        guard category.items.indices.contains(itemIndex) else { return }
        category.items[itemIndex].isCompleted.toggle()
        saveChanges()
    }

    private func saveChanges() {
        // Notify the parent ViewModel that the category has changed
        onCategoryChanged(category)
    }
}
