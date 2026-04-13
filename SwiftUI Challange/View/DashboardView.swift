import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: CategoryViewModel

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
