// SwiftUI Challange/ViewModel/CategoryViewModel.swift
import Foundation
import Combine // Needed for ObservableObject
import SwiftUI //Needed for remove(atOffsets: offsets)

/*    ObservableObject: The CategoryViewModel is designed to hold the state and logic related
     to categories (like the list of categories, adding/deleting them, and managing
     persistence). To allow SwiftUI views to observe and react to changes in this state, the
     CategoryViewModel class conforms to the ObservableObject protocol.
*/
class CategoryViewModel: ObservableObject {
    @Published var categoryArray: [Category] = []

    init() {
        loadCategories()
    }

    private func loadCategories() {
        categoryArray = CategoryStorage.load()
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

    // This method is called by CategoryDetailViewModel when a category's properties change.
    func updateAndSaveCategory(_ updatedCategory: Category) {
        if let index = categoryArray.firstIndex(where: { $0.id == updatedCategory.id }) {
            categoryArray[index] = updatedCategory
            saveCategories()
        }
    }

    public func saveCategories() {
        CategoryStorage.save(categoryArray)
    }
}
