//
//  HabitViewModel.swift
//  SwiftUI Challange
//
//  Created by Gemini on 09/04/26.
//

import SwiftUI
import Combine

class HabitViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var newHabitTitle: String = ""
    
    func addHabit() {
        guard !newHabitTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        withAnimation {
            habits.append(Habit(title: newHabitTitle, isCompleted: false))
        }
        newHabitTitle = ""
    }
    
    func deleteHabit(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }
    
    var isAddButtonDisabled: Bool {
        newHabitTitle.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
