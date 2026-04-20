// Personal Organizer/ViewModel/CategoryViewModel.swift
import Foundation
import Combine // Needed for ObservableObject
import SwiftUI //Needed for remove(atOffsets: offsets)

/*    ObservableObject: The CategoryViewModel is designed to hold the state and logic related
     to categories (like the list of categories, adding/deleting them, and managing
     persistence). To allow SwiftUI views to observe and react to changes in this state, the
     CategoryViewModel class conforms to the ObservableObject protocol.
*/
@MainActor
@Observable
class CategoryViewModel {
    var categoryArray: [Category] = []
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
    
    func moveCategory(from source:IndexSet, to destination: Int) {
        categoryArray.move(fromOffsets: source, toOffset: destination)
        saveCategories()
    }
    
    func renameCategory(id: UUID, newTitle: String) {
        guard !newTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        if let index = categoryArray.firstIndex(where: { $0.id == id }) {
            categoryArray[index].title = newTitle
            saveCategories()
        }
    }
    
    // Statistics for the dashboard
    var totalItemsCount: Int {
        categoryArray.reduce(0) { $0 + $1.items.count }
//        var count = 0
//        for category in categoryArray {
//            count += category.items.count
//        }
//        return count
    }
    
    var totalCompletedCount: Int {
        categoryArray.reduce(0) { $0 + $1.items.filter { $0.isCompleted }.count }
        
        //Alternate logic for the above implementation
//        var count = 0
//        for category in categoryArray {
//            count += category.items.filter { $0.isCompleted }.count
//        }
//        return count
    }
    
    var completionPercentage: Double {
        guard totalItemsCount > 0 else { return 0 }
        return Double(totalCompletedCount) / Double(totalItemsCount)
    }
}
