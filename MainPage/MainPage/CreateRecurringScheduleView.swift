import SwiftUI

struct CreateRecurringScheduleView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: SchedulesStore

    @State private var supporterName: String = ""
    @State private var supporterEmail: String = ""
    @State private var amountText: String = ""
    @State private var startDate: Date = Date()
    @FocusState private var focusedField: Field?

    @State private var showSupporterEditor: Bool = false
    @State private var frequency: Frequency = .monthly

    private enum Field: Hashable {
        case name, email, amount
    }

    private enum Frequency: String, CaseIterable { case monthly = "Monthly", yearly = "Yearly" }

    var onCreate: (RecurringSchedule) -> Void

    var body: some View {
        VStack(spacing: 20) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(
                        LinearGradient(colors: [.brandAccent, .brandPrimary.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 28, style: .continuous).stroke(Color.white.opacity(0.15), lineWidth: 1))
                    .frame(height: 120)
                    .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recurring Donations")
                        .font(.system(.title2, design: .rounded).weight(.semibold))
                        .foregroundColor(.white)
                    Text("Create a recurring support plan")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.9))
                }
                .padding(.horizontal)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Supporter")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.brandPrimary)

                // Summary card
                Button(action: { withAnimation { showSupporterEditor.toggle() } }) {
                    HStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.brandPrimary)
                            .frame(width: 36, height: 36)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(supporterName.isEmpty ? "Mohamed Ahmed" : supporterName)
                                .font(.system(.body, design: .rounded).weight(.semibold))
                                .foregroundColor(.primary)
                            Text(supporterEmail.isEmpty ? "mohamedahmed@gmail.com" : supporterEmail)
                                .font(.system(.footnote, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(Color.brandAccent.opacity(0.15), lineWidth: 1))
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                }

                if showSupporterEditor {
                    VStack(spacing: 8) {
                        TextField("Full name (as on ID)", text: $supporterName)
                            .font(.system(.body, design: .rounded))
                            .textContentType(.name)
                            .focused($focusedField, equals: .name)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color(.secondarySystemGroupedBackground)))
                            .autocorrectionDisabled(true)

                        TextField("Email address", text: $supporterEmail)
                            .font(.system(.body, design: .rounded))
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .focused($focusedField, equals: .email)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color(.secondarySystemGroupedBackground)))
                            .autocorrectionDisabled(true)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Recurring Donation Amount")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.brandPrimary)

                HStack(spacing: 8) {
                    TextField("50", text: $amountText)
                        .font(.system(.body, design: .rounded))
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .amount)

                    Text("$")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundColor(.primary)
                        .frame(width: 40, height: 36)
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color(.secondarySystemGroupedBackground)))

                Text("Amount")
                    .font(.system(.footnote, design: .rounded))
                    .foregroundColor(.secondary)
            }
            .onChange(of: amountText) { newValue in
                let filtered = newValue.filter { "0123456789.".contains($0) }
                if filtered != newValue { amountText = filtered }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Giving Frequency")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.brandPrimary)

                HStack(spacing: 12) {
                    frequencyPill(title: "Monthly", selected: frequency == .monthly) { frequency = .monthly }
                    frequencyPill(title: "Yearly", selected: frequency == .yearly) { frequency = .yearly }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Date of Donation")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.brandPrimary)

                DatePicker("", selection: $startDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(.secondarySystemGroupedBackground)))
            }

            Button(action: create) {
                Text("Create Recurring Schedule")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(AccentProminentButtonStyle())
            .disabled(!isValid)
            .opacity(isValid ? 1.0 : 0.6)

            Text("We’ll send a receipt to your email and you can manage this plan anytime.")
                .font(.system(.footnote, design: .rounded))
                .foregroundColor(.secondary)
                .padding(.top, 4)

            Spacer()
        }
        .padding()
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
                    .foregroundColor(.brandPrimary)
            }
        }
        .tint(.brandPrimary)
    }

    private func frequencyPill(title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(selected ? Color.brandPrimary.opacity(0.12) : Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(selected ? Color.brandPrimary : Color(white: 0.85), lineWidth: 1)
                )
                .foregroundColor(selected ? .brandAccent : .primary)
        }
        .buttonStyle(.plain)
    }

    struct AccentProminentButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.system(.headline, design: .rounded))
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.brandPrimary)
                        .opacity(configuration.isPressed ? 0.85 : 1.0)
                )
                .foregroundColor(.white)
                .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
        }
    }

    private var isValid: Bool {
        !supporterName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !supporterEmail.trimmingCharacters(in: .whitespaces).isEmpty &&
        Double(amountText) != nil
    }

    private func create() {
        guard let amount = Double(amountText) else { return }
        let schedule = RecurringSchedule(supporterName: supporterName, supporterEmail: supporterEmail, amountBHD: amount, startDate: startDate)
        onCreate(schedule)
        dismiss()
    }
}

#Preview {
    NavigationView { CreateRecurringScheduleView { _ in } }
}
