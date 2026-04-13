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
    @State private var showRenameItemAlert: Bool = false
    @State private var renamingItemID: UUID?
    @State private var renamingItemTitle: String = ""

    var body: some View {
        List {
            // Use items from the ViewModel's category
            ForEach(viewModel.category.items) { item in
                HStack {
                    Text(item.title)
                        .strikethrough(item.isCompleted)
                        .foregroundColor(item.isCompleted ? .gray : .primary)
                    Spacer()
                    
                    Button {
                        // Call ViewModel method to toggle completion
                        viewModel.toggleItemCompletion(item: item)
                    } label: {
                        Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                    }
                    .buttonStyle(.plain)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        if let index = viewModel.category.items.firstIndex(where: { $0.id == item.id }) {
                            viewModel.deleteItem(at: IndexSet(integer: index))
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    Button {
                        renamingItemID = item.id
                        renamingItemTitle = item.title
                        showRenameItemAlert = true
                    } label: {
                        Label("Rename", systemImage: "pencil")
                    }
                    .tint(.orange)
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
        .alert("Rename Item", isPresented: $showRenameItemAlert) {
            TextField("New Item Name", text: $renamingItemTitle)
            Button("Rename") {
                if let id = renamingItemID {
                    viewModel.renameItem(id: id, newTitle: renamingItemTitle)
                }
                renamingItemID = nil
            }
            Button("Cancel", role: .cancel) {
                renamingItemID = nil
            }
        } message: {
            Text("Please enter a new name for the item.")
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
