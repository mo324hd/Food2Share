import SwiftUI

public struct RecurringSchedulesListView: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Text("No schedules yet")
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("Recurring Schedules")
        }
    }
}

#Preview {
    RecurringSchedulesListView()
}
