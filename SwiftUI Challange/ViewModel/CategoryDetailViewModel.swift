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

    func toggleItemCompletion(item: Item) {
        if let index = category.items.firstIndex(where: { $0.id == item.id }) {
            category.items[index].isCompleted.toggle()
        }
    }

    func moveItem(from source: IndexSet, to destination: Int) {
        withAnimation {
            category.items.move(fromOffsets: source, toOffset: destination)
        }
    }

    func renameItem(id: UUID, newTitle: String) {
        guard !newTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        if let index = category.items.firstIndex(where: { $0.id == id }) {
            category.items[index].title = newTitle
        }
    }
}
