//
//  AddCategoryView.swift
//  SwiftUI Challange
//
//  Created by Johnson on 09/04/26.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    
    @State private var title: String = ""
    
    var onSave: (Category) -> Void
        
        
    var body: some View {
        
        
        VStack(spacing: 20) {
            
            TextField("Enter category name...", text: $title)
                .focused($isFocused)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.words)
            Button("Save") {
                saveCategory()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(titleIsValid ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(!titleIsValid)
            
            Spacer()
        }
        .padding()
        .navigationTitle("New Category")
        
    }
    
    var titleIsValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    func saveCategory() {
        let newCategory = Category(
            id: UUID(),
            title: title,
            items: []
        )
        onSave(newCategory)
        dismiss()
    }
}
