import SwiftUI

struct SchedulesHomeView: View {
    @StateObject private var viewModel = DonationSchedulesViewModel()
    @State private var showingCreate = false

    var body: some View {
        NavigationStack {
            Group {
                // Placeholder content in case list rendering is defined elsewhere
                VStack(spacing: 16) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 48))
                        .foregroundStyle(.purple)
                    Text("Donation Schedules")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Create and manage your recurring donations.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("Schedules")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingCreate = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Create Recurring Schedule")
                }
            }
            .sheet(isPresented: $showingCreate) {
                CreateRecurringScheduleView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    SchedulesHomeView()
}
