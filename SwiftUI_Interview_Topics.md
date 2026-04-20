# SwiftUI Interview Preparation Checklist

## 1. The Essentials (Must-Know)
- [ ] **View Lifecycle:** Understanding `body` property re-calculation, `onAppear`, and `onDisappear`.
- [ ] **State Management:**
    - `@State` vs `@Binding` (local vs. shared state).
    - `@StateObject` vs `@ObservedObject` (ownership vs. observation).
    - `@EnvironmentObject` (dependency injection).
    - `@Environment` (system settings access).
- [ ] **Layout System:** `HStack`, 1`VStack`, `ZStack`, `Spacer`, `Padding`, and `Frame` usage.
- [ ] **Lists and ForEach:** Rendering dynamic data and the importance of `Identifiable`.

## 2. Architecture & Data Flow
- [ ] **MVVM Pattern:** Separating business logic (ViewModel) from UI (View).
- [ ] **Data Binding:** Two-way binding (`$`) and one-way data flow.
- [ ] **Protocols & Macros:** `ObservableObject` and the modern `@Observable` macro.
- [ ] **Dependency Injection:** Injecting services (e.g., storage managers) into ViewModels.

## 3. Intermediate Topics
- [ ] **Navigation:** Using `NavigationStack` and `NavigationPath`.
- [ ] **Modals:** Sheets and `fullScreenCover` presentation states.
- [ ] **Persistence:** `UserDefaults`, `@AppStorage`, and `SwiftData`.
- [ ] **Networking:** `URLSession` and `Codable` for JSON parsing.
- [ ] **Combine:** Basics of publishers (e.g., search debounce).

## 4. Advanced Concepts
- [ ] **Performance:** Minimizing view re-renders.
- [ ] **ViewModifiers:** Creating custom, reusable view modifiers.
- [ ] **Accessibility:** `accessibilityLabel`, `accessibilityHint`, and dynamic type support.
- [ ] **Swift Concurrency:** `async/await` and `@MainActor` for thread-safe UI updates.

---

## Common Interview Questions
- *How does SwiftUI trigger automatic UI updates?*
- *Difference between `@StateObject` and `@ObservedObject`?*
- *How do you pass data from a child view to a parent?*
