//
//  ContentView.swift
//  SwiftUI Challange
//
//  Created by Johnson on 07/04/26.
//

import SwiftUI



struct ContentView: View {
    
    @StateObject private var viewModel = HabitViewModel()
    @State private var previousCount: Int = 0
    
    var body: some View {
        
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
                    
                    Text("John Corner")
                        .font(.title)
                        .bold()
                }
            }
            ScrollViewReader { proxy in
                List {
                    Section (header: Text("Grocery List")) {
                        ForEach($viewModel.habits) { $habit in
                            HabitRow(
                                title: $habit.wrappedValue.title,
                                isCompleted: $habit.isCompleted
                            )
                            .id(habit.id)
                        }
                        .onDelete(perform: viewModel.deleteHabit)
                    }
                }
                
                .onChange(of: viewModel.habits.count) { _, newCount in
                    
                    if newCount > previousCount {
                        scrollToBottom(proxy: proxy)
                    }
                    previousCount = newCount
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
    
    func scrollToBottom(proxy: ScrollViewProxy) {
        guard let last = viewModel.habits.last else { return }
        withAnimation {
            proxy.scrollTo(last.id, anchor: .bottom)
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
        .cornerRadius(20)
    }
}

#Preview {
    ContentView()
}
