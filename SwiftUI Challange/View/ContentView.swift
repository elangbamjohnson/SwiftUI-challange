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
    @StateObject private var viewModel = CategoryViewModel()
    
    /*
     @State is used to manage value types (like structs, enums, Int, String, Bool) that are owned
          and managed by a single view. Here newCategoryTitle and showAddCategoryAlert are locally manage variable
     */
    @State private var newCategoryTitle: String = ""
    @State private var showAddCategoryAlert: Bool = false
    
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
                        // Pass a CategoryDetailViewModel to the CategoryDetailView
                        CategoryDetailView(viewModel: CategoryDetailViewModel(
                            category: category,
                            onCategoryChanged: { updatedCategory in
                                viewModel.updateAndSaveCategory(updatedCategory)
                            })
                        )
                    } label: {
                        HStack {
                            Text(category.title)
                            Spacer()
                            Text("\(category.items.count)")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete { indexSet in
                    viewModel.deleteCategory(at: indexSet) // Call ViewModel method
                }
            }
            
            .listStyle(.insetGrouped)
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddCategoryAlert = true
                    } label: {
                        Image(systemName: "plus")
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
        }
    }
}

#Preview {
    ContentView()
}
