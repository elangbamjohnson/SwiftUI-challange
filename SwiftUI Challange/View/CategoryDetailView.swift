//
//  CatgoryDetailView.swift
//  SwiftUI Challange
//
//  Created by Johnson on 09/04/26.
//

import SwiftUI

struct CategoryDetailView: View {
    @Binding var category: Category
    @State private var newItemTitle: String = ""
    
    var body: some View {
        List {
            ForEach($category.items) { $item in
                
                HStack {
                    Text(item.title)
                        .strikethrough(item.isCompleted)
                    Spacer()
                    
                    Button {
                        item.isCompleted.toggle()
                    } label: {
                        Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                        
                    }
                    .buttonStyle(.plain)
                }
                
            }
            .onDelete(perform: deleteItem)
        }
        .navigationTitle(category.title)
        .safeAreaInset(edge: .bottom) {
            addItemSection
                .background(.ultraThinMaterial)
        }
    }
    
    var addItemSection: some View {
        VStack {
            TextField("Add item...", text: $newItemTitle)
                .textFieldStyle(.roundedBorder)
            Button("Add Item") {
                addItem()
            }
        }
        .padding()
    }
    
    //@MainActor
    func addItem() {
        guard !newItemTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let newItem = Item(
            id: UUID(),
            title: newItemTitle,
            isCompleted: false
        )
        category.items.insert(newItem, at: 0)
        
        
        newItemTitle = ""
        
    }
    
    func deleteItem(at offsets: IndexSet) {
        category.items.remove(atOffsets: offsets)
    }
}
