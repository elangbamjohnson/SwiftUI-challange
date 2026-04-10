// SwiftUI Challange/ViewModel/CategoryViewModel.swift
import Foundation
import Combine // Needed for ObservableObject
import SwiftUI //Needed for remove(atOffsets: offsets)

/*    ObservableObject: The CategoryViewModel is designed to hold the state and logic related
     to categories (like the list of categories, adding/deleting them, and managing
     persistence). To allow SwiftUI views to observe and react to changes in this state, the
     CategoryViewModel class conforms to the ObservableObject protocol.
*/
@MainActor
class CategoryViewModel: ObservableObject {
    @Published var categoryArray: [Category] = []
    private let storage: CategoryStorageProtocol

    init(storage: CategoryStorageProtocol = CategoryStorage()) {
        self.storage = storage
        loadCategories()
    }

    private func loadCategories() {
        categoryArray = storage.load()
    }

    func addCategory(title: String) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newCategory = Category(id: UUID(), title: title, items: [])
        categoryArray.insert(newCategory, at: 0)
        saveCategories()
    }

    func deleteCategory(at offsets: IndexSet) {
        categoryArray.remove(atOffsets: offsets)
        saveCategories()
    }

    public func saveCategories() {
        storage.save(categoryArray)
    }
}
