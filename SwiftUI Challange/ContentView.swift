//
//  ContentView.swift
//  SwiftUI Challange
//
//  Created by Johnson on 07/04/26.
//

import SwiftUI



struct ContentView: View {
    
    @StateObject private var viewModel = HabitViewModel()
    
    var body: some View {
        
//        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Profile Section
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text("Welcome back,")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("Jereme")
                            .font(.title)
                            .bold()
                    }
                }
                
                Text("Today's Habits")
                    .font(.headline)
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach($viewModel.habits) { $habit in
                            HabitRow(
                                title: $habit.wrappedValue.title,
                                isCompleted: $habit.isCompleted
                            )
                        }
                    }
                }
            }
            .padding()
        
        // 👇 THIS FIXES KEYBOARD ISSUE
        .safeAreaInset(edge: .bottom) {
            addHabitSection
                .background(.ultraThinMaterial)
        }
    }
    
    // MARK: - Bottom Input View
    var addHabitSection: some View {
        
        VStack(spacing: 10) {
            
            TextField("Enter new habit...", text: $viewModel.newHabitTitle)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.words)
            
            Button {
                viewModel.addHabit()
            } label: {
                Text("+ Add Habit")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(viewModel.isAddButtonDisabled)
        }
        .padding()
        
    }
}

struct HabitRow: View {
    
    var title: String
    
    @Binding var isCompleted : Bool
    
    var body: some View {
        HStack {
            Text(title)
                .strikethrough(isCompleted)
                .foregroundColor(isCompleted ? .gray : .primary)
                .animation(.easeInOut, value: isCompleted)
                
            Spacer()
            Button {
                withAnimation {
                    isCompleted.toggle()
                }
                
            } label: {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isCompleted ? .green : .gray)
                    
                    
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
    }
}

#Preview {
    ContentView()
}
