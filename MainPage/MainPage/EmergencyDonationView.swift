import SwiftUI

struct EmergencyDonationView: View {
    @State private var amount: String = ""

    var body: some View {
        Form {
            Section(header: Text("Amount")) {
                TextField("Enter amount", text: $amount)
                    .keyboardType(.decimalPad)
            }

            Section {
                Button("Donate now") {
                    // Hook up to your donation logic
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("Emergency donation")
    }
}

#Preview {
    NavigationView { EmergencyDonationView() }
}
