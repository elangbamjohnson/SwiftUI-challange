//
//  ContentView.swift
//  SwiftUI Challange
//
//  Created by Johnson on 07/04/26.
//

import SwiftUI


struct ContentView: View {
    
    @State private var categories: [Category] = CategoryStorage.load()
    @State private var newCategoryTitle: String = ""
    
    var body: some View {
        
        NavigationStack {
            List {
                
                // MARK: - Empty State
                if categories.isEmpty {
                    Text("No categories yet")
                        .foregroundColor(.gray)
                }
                
                // MARK: - Categories List
                ForEach($categories) { $category in
                    
                    NavigationLink {
                        CategoryDetailView(category: $category)
                    } label: {
                        HStack {
                            Text(category.title)
                            
                            Spacer()
                            
                            Text("\(category.items.count)")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: deleteCategory)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Categories")
            
            // MARK: - Add Button
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addCategory()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        
        // MARK: - Auto Save
        .onChange(of: categories) { _ in
            CategoryStorage.save(categories)
        }
    }
    
    // MARK: - Add Category
    func addCategory() {
        let newCategory = Category(
            id: UUID(),
            title: "New Category",
            items: []
        )
        
        withAnimation {
            categories.insert(newCategory, at: 0)
        }
    }
    
    // MARK: - Delete Category
    func deleteCategory(at offsets: IndexSet) {
        withAnimation {
            categories.remove(atOffsets: offsets)
        }
    }
}



#Preview {
    ContentView()
}
