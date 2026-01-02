import SwiftUI

struct RecurringDonationsListView: View {
    var body: some View {
        List {
            Section("Recurring Donations") {
                Text("No donations yet")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Donations")
    }
}

#Preview {
    NavigationStack { RecurringDonationsListView() }
}
