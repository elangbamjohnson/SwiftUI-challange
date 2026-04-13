//
//  ContentView.swift
//  SwiftUI Challange
//
//  Created by Johnson on 07/04/26.
//

import SwiftUI

struct ContentView: View {
    /*
     @StateObject's Role: @StateObject is a property wrapper that tells SwiftUI to create and
     manage an instance of an ObservableObject for the lifetime of the view.
     In our case CategoryViewModel conforms to ObservableObject.
     Use StateObject for ViewModel
     * Initialization: When ContentView is first created, @StateObject initializes the
     CategoryViewModel.
     * Persistence: Crucially, @StateObject ensures that the ViewModel instance persists
     across view updates and re-renders of ContentView. This means the ViewModel's state
     (like the list of categories) is preserved, preventing it from being recreated with
     default values every time the UI refreshes.
     * Ownership: It signifies that ContentView owns this ViewModel. It's responsible for
     its creation and lifecycle.
     */
    @State private var viewModel = CategoryViewModel()
    
    /*
     @State is used to manage value types (like structs, enums, Int, String, Bool) that are owned
          and managed by a single view. Here newCategoryTitle and showAddCategoryAlert are locally manage variable
     */
    @State private var newCategoryTitle: String = ""
    @State private var showAddCategoryAlert: Bool = false
    @State private var showRenameCategoryAlert: Bool = false
    @State private var renamingCategoryID: UUID?
    @State private var renamingCategoryTitle: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.categoryArray.isEmpty {
                    Text("No categories yet")
                        .foregroundColor(.gray)
                }
                    
                
                // Use the ViewModel's categories
                ForEach($viewModel.categoryArray) { $category in
                    NavigationLink {
                        // Create the ViewModel and capture it to update the parent on disappear
                        let detailViewModel = CategoryDetailViewModel(category: category)
                        CategoryDetailView(viewModel: detailViewModel)
                            .onDisappear {
                                // Update the parent's category list with the modified one from the detail view
                                if let index = viewModel.categoryArray.firstIndex(where: { $0.id == detailViewModel.category.id }) {
                                    viewModel.categoryArray[index] = detailViewModel.category
                                    viewModel.saveCategories()
                                }
                            }
                    } label: {
                        HStack {
                            Text(category.title)
                            Spacer()
                            Text("\(category.items.count)")
                                .foregroundColor(.gray)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            if let index = viewModel.categoryArray.firstIndex(where: { $0.id == category.id }) {
                                viewModel.deleteCategory(at: IndexSet(integer: index))
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        Button {
                            renamingCategoryID = category.id
                            renamingCategoryTitle = category.title
                            showRenameCategoryAlert = true
                        } label: {
                            Label("Rename", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }
                .onDelete { indexSet in
                    viewModel.deleteCategory(at: indexSet) // Call ViewModel method
                }
                .onMove { source, destination in
                    viewModel.moveCategory(from: source, to: destination)
                }
            }
            
            .listStyle(.insetGrouped)
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddCategoryAlert = true
                    } label: {
                        Image(systemName: "plus") // Keep adding
                    }
                }
            }
            .alert("Add New Category", isPresented: $showAddCategoryAlert) {
                TextField("Category Name", text: $newCategoryTitle)
                Button("Add") {
                    viewModel.addCategory(title: newCategoryTitle) // Call ViewModel method
                    newCategoryTitle = "" // Clear the text field
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Please enter a name for your new category.")
            }
            .alert("Rename Category", isPresented: $showRenameCategoryAlert) {
                TextField("New Category Name", text: $renamingCategoryTitle)
                Button("Rename") {
                    if let id = renamingCategoryID {
                        viewModel.renameCategory(id: id, newTitle: renamingCategoryTitle)
                    }
                    renamingCategoryID = nil
                }
                Button("Cancel", role: .cancel) {
                    renamingCategoryID = nil
                }
            } message: {
                Text("Please enter a new name for the category.")
            }
        }
    }
}

#Preview {
    ContentView()
}
