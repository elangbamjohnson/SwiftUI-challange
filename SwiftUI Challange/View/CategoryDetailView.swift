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
            ForEach(viewModel.category.items.indices, id: \.self) { index in
                HStack {
                    Text(viewModel.category.items[index].title)
                        .strikethrough(viewModel.category.items[index].isCompleted)
                    Spacer()
                    
                    Button {
                        // Call ViewModel method to toggle completion
                        viewModel.toggleItemCompletion(itemIndex: index)
                    } label: {
                        Image(systemName: viewModel.category.items[index].isCompleted ? "checkmark.circle" : "circle")
                    }
                    .buttonStyle(.plain)
                }
            }
            .onDelete { indexSet in
                viewModel.deleteItem(at: indexSet) // Call ViewModel method
            }
        }
        .navigationTitle(viewModel.category.title) // Use ViewModel's title
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
