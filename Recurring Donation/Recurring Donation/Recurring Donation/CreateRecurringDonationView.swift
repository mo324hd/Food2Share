import SwiftUI

struct CreateRecurringDonationView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: RecurringDonationsStore

    @State private var supporterName: String = ""
    @State private var supporterEmail: String = ""
    @State private var amountText: String = ""
    @State private var frequency: DonationFrequency = .monthly
    @State private var date: Date = .now

    var body: some View {
        NavigationStack {
            ScrollView {
                header
                formContent
            }
            .background(Color(.systemBackground))
        }
    }

    private var header: some View {
        ZStack(alignment: .topLeading) {
            Color.brandPurple
                .frame(height: 120)
                .ignoresSafeArea(edges: .top)
            Text("Recurring Donations")
                .font(.system(.title2, design: .rounded)).bold()
                .foregroundStyle(.black)
                .padding(.top, 16)
                .padding(.leading, 20)
        }
    }

    private var formContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            Group {
                Text("Supporter")
                    .font(.headline)
                VStack(alignment: .leading, spacing: 8) {
                    TextField("Full name", text: $supporterName)
                        .textContentType(.name)
                        .textFieldStyle(.roundedBorder)
                    TextField("email@example.com", text: $supporterEmail)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textFieldStyle(.roundedBorder)
                }
            }

            Group {
                Text("Recurring Donation Amount")
                    .font(.headline)
                HStack {
                    TextField("Amount", text: $amountText)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                    Text("$")
                        .font(.headline)
                        .padding(.horizontal, 8)
                }
            }

            Group {
                Text("Giving Frequency")
                    .font(.headline)
                HStack {
                    frequencyButton(.monthly)
                    frequencyButton(.yearly)
                }
            }

            Group {
                Text("Date of Donation")
                    .font(.headline)
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.compact)
            }

            Button(action: create) {
                Text("Create Recurring Schedule")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.brandPurple))
            }
            .padding(.top, 12)
        }
        .padding(20)
    }

    private func frequencyButton(_ value: DonationFrequency) -> some View {
        Button(action: { frequency = value }) {
            Text(value.rawValue)
                .font(.subheadline).bold()
                .foregroundStyle(frequency == value ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    Capsule().fill(frequency == value ? Color.brandPurple : Color(.systemGray5))
                )
        }
    }

    private func create() {
        guard let amount = Decimal(string: amountText), !supporterName.isEmpty else { return }
        let supporter = Supporter(name: supporterName, email: supporterEmail)
        let donation = RecurringDonation(supporter: supporter, amount: amount, frequency: frequency, nextDate: date)
        store.add(donation)
        dismiss()
    }
}

private extension Color {
    static let brandPurple = Color(red: 108/255, green: 71/255, blue: 205/255)
}

#Preview {
    CreateRecurringDonationView(store: RecurringDonationsStore())
}
