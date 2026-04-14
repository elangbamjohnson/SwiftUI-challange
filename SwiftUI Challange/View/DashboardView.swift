import SwiftUI

struct DashboardView: View {
    // Since CategoryViewModel uses @Observable, we should use it directly 
    // or just pass it as a regular property if the view doesn't own it.
    var viewModel: CategoryViewModel

    var body: some View {
        NavigationStack {
            List {
                Section("Summary") {
                    LabeledContent("Total Items", value: "\(viewModel.totalItemsCount)")
                    LabeledContent("Completed", value: "\(viewModel.totalCompletedCount)")
                }
                
                Section("Progress") {
                    ProgressView(value: viewModel.completionPercentage)
                        .tint(.blue)
                    Text("\(Int(viewModel.completionPercentage * 100))% Completed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Dashboard")
        }
    }
}
