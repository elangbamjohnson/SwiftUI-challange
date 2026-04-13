//
//  CatgoryDetailView.swift
//  SwiftUI Challange
//
//  Created by Johnson on 09/04/26.
//

import SwiftUI

struct CategoryDetailView: View {
    // Use StateObject for the ViewModel
    @StateObject var viewModel: CategoryDetailViewModel

    var body: some View {
        List {
            // Use items from the ViewModel's category
            ForEach(viewModel.category.items) { item in
                HStack {
                    Text(item.title)
                        .strikethrough(item.isCompleted)
                        .foregroundColor(item.isCompleted ? .gray : .black)
                    Spacer()
                    
                    Button {
                        // Call ViewModel method to toggle completion
                        viewModel.toggleItemCompletion(item: item)
                    } label: {
                        Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                    }
                    .buttonStyle(.plain)
                }
            }
            .onDelete { indexSet in
                viewModel.deleteItem(at: indexSet) // Call ViewModel method
            }
            .onMove { source, destination in
                viewModel.moveItem(from: source, to: destination)
            }
        }
       
        .navigationTitle(viewModel.category.title) // Use ViewModel's title
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
        }
        .safeAreaInset(edge: .bottom) {
            addItemSection
                .background(.ultraThinMaterial)
        }
    }
    
    var addItemSection: some View {
        VStack {
            // Bind TextField directly to ViewModel's published property
            TextField("Add item...", text: $viewModel.newItemTitle)
                .textFieldStyle(.roundedBorder)
            Button("Add Item") {
                viewModel.addItem() // Call ViewModel method that uses its own newItemTitle
            }
        }
        .padding()
    }
}
