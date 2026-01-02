import SwiftUI

struct CreateRecurringScheduleView: View {
    @ObservedObject var viewModel: DonationSchedulesViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var donorName = ""
    @State private var donorEmail = ""
    @State private var amountText = ""
    @State private var frequency: RecurringSchedule.Frequency = .monthly
    @State private var date = Date()

    private var amountDecimal: Decimal? {
        let filtered = amountText.filter { "0123456789.".contains($0) }
        return Decimal(string: filtered)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HeaderCard(title: "Recurring Donations")
                    .padding(.horizontal)
                    .padding(.top)

                VStack(alignment: .leading, spacing: 16) {
                    Text("Supporter")
                        .font(.headline)

                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.purple.opacity(0.2))
                            .frame(width: 44, height: 44)
                            .overlay {
                                Image(systemName: "person.crop.circle")
                                    .font(.title2)
                                    .foregroundStyle(Color.purple)
                            }
                        VStack(spacing: 8) {
                            TextField("Mohamed Ahmed", text: $donorName)
                                .textContentType(.name)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled(true)
                                .font(.body)
                            TextField("mohamedahmed@gmail.com", text: $donorEmail)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled(true)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Recurring Donation Amount")
                        .font(.headline)
                    AmountEntryField(amountText: $amountText)
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Giving Frequency")
                        .font(.headline)
                    HStack(spacing: 12) {
                        pill(title: "Monthly", selected: frequency == .monthly) { frequency = .monthly }
                        pill(title: "Yearly", selected: frequency == .yearly) { frequency = .yearly }
                    }
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Date of Donation")
                        .font(.headline)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(UIColor.systemGray6))
                            .frame(height: 48)
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .labelsHidden()
                            .padding(.horizontal)
                    }
                }
                .padding(.horizontal)

                Button(action: createSchedule) {
                    Text("Create Recurring Schedule")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
                .clipShape(Capsule())
                .padding(.horizontal)
                .disabled(!isFormValid)
            }
            .padding(.bottom)
        }
    }

    private var isFormValid: Bool {
        amountDecimal != nil && !donorName.trimmingCharacters(in: .whitespaces).isEmpty && !donorEmail.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func createSchedule() {
        guard let amt = amountDecimal else { return }
        let schedule = RecurringSchedule(
            id: UUID(),
            donorName: donorName.trimmingCharacters(in: .whitespaces),
            donorEmail: donorEmail.trimmingCharacters(in: .whitespaces),
            amount: amt,
            frequency: frequency,
            startDate: date
        )
        viewModel.addSchedule(schedule)
        dismiss()
    }

    @ViewBuilder
    private func pill(title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
        }
        .buttonStyle(selected ? .borderedProminent : .bordered)
        .tint(.purple)
        .clipShape(Capsule())
    }
}

private struct AmountEntryField: View {
    @Binding var amountText: String

    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                TextField("50$", text: $amountText)
                    .keyboardType(.decimalPad)
                    .padding(.vertical, 10)
                    .padding(.leading, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(UIColor.systemGray6))
                    )
                Text("Amount")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 6)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(UIColor.systemGray6))
                    .frame(width: 48, height: 48)
                Image(systemName: "dollarsign")
                    .font(.headline)
            }
        }
    }
}

#Preview {
    CreateRecurringScheduleView(viewModel: DonationSchedulesViewModel())
}
