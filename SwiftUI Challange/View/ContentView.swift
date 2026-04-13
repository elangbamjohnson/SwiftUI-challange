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
    @State private var newCategoryIcon: String = "list.bullet"
    @State private var newCategoryColor: Color = .blue
    @State private var showAddCategoryAlert: Bool = false
    @State private var showRenameCategoryAlert: Bool = false
    @State private var renamingCategoryID: UUID?
    @State private var renamingCategoryTitle: String = ""

    // Simple hex helper for Color
    private func hexString(from color: Color) -> String {
        let uiColor = UIColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.categoryArray.isEmpty {
                    Text("No categories yet")
                        .foregroundColor(.gray)
                }
                
                ForEach($viewModel.categoryArray) { $category in
                    NavigationLink {
                        let detailViewModel = CategoryDetailViewModel(category: category)
                        CategoryDetailView(viewModel: detailViewModel)
                            .onDisappear {
                                if let index = viewModel.categoryArray.firstIndex(where: { $0.id == detailViewModel.category.id }) {
                                    viewModel.categoryArray[index] = detailViewModel.category
                                    viewModel.saveCategories()
                                }
                            }
                    } label: {
                        HStack {
                            Image(systemName: category.iconName)
                                .foregroundColor(Color(hex: category.colorHex))
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
                    viewModel.deleteCategory(at: indexSet)
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
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddCategoryAlert) {
                NavigationStack {
                    Form {
                        TextField("Category Name", text: $newCategoryTitle)
                        ColorPicker("Category Color", selection: $newCategoryColor)
                        Section("Icon") {
                             // Simple mock icon picker
                             TextField("System Icon Name", text: $newCategoryIcon)
                        }
                    }
                    .navigationTitle("New Category")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                viewModel.addCategory(title: newCategoryTitle, iconName: newCategoryIcon, colorHex: hexString(from: newCategoryColor))
                                newCategoryTitle = ""
                                showAddCategoryAlert = false
                            }
                        }
                    }
                }
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

// Add this extension for Color(hex:)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

#Preview {
    ContentView()
}
