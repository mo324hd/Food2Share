import SwiftUI

struct RecurringSchedulesListView: View {
    @StateObject private var viewModel = DonationSchedulesViewModel()
    @State private var showingCreate = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    HeaderCard(title: "Recurring Donations")
                        .padding(.horizontal)
                        .padding(.top)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Set up automatic donation schedules")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Button(action: { showingCreate = true }) {
                            Text("Create Recurring Schedule")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.purple)
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Current Recurring Schedules :")
                            .font(.headline)

                        if viewModel.schedules.isEmpty {
                            // Show examples grouped by frequency
                            GroupedSchedulesView(
                                title: "Yearly Donation",
                                schedules: DonationSchedulesViewModel.exampleSchedules().filter { $0.frequency == .yearly }
                            )
                            GroupedSchedulesView(
                                title: "Monthly Donation",
                                schedules: DonationSchedulesViewModel.exampleSchedules().filter { $0.frequency == .monthly }
                            )
                        } else {
                            // Group actual schedules by frequency
                            let yearly = viewModel.schedules.filter { $0.frequency == .yearly }
                            let monthly = viewModel.schedules.filter { $0.frequency == .monthly }

                            if !yearly.isEmpty {
                                GroupedSchedulesView(title: "Yearly Donation", schedules: yearly)
                            }
                            if !monthly.isEmpty {
                                GroupedSchedulesView(title: "Monthly Donation", schedules: monthly)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationDestination(isPresented: $showingCreate) {
                CreateRecurringScheduleView(viewModel: viewModel)
            }
        }
    }
}

private struct HeaderCard: View {
    let title: String
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Curved purple header shape approximation
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.purple.opacity(0.2))
                .frame(height: 90)
                .overlay(alignment: .topTrailing) {
                    Circle()
                        .fill(Color.purple)
                        .frame(width: 80, height: 80)
                        .offset(x: 24, y: -24)
                        .clipped()
                }
            Text(title)
                .font(.title)
                .bold()
                .padding(.leading, 16)
                .padding(.top, 16)
        }
    }
}

private struct GroupedSchedulesView: View {
    let title: String
    let schedules: [RecurringSchedule]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)

            ForEach(schedules) { schedule in
                ScheduleCard(schedule: schedule)
            }
        }
    }
}

private struct ScheduleCard: View {
    let schedule: RecurringSchedule

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.purple.opacity(0.2))
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: "person.crop.circle")
                            .font(.title2)
                            .foregroundStyle(Color.purple)
                    }
                VStack(alignment: .leading, spacing: 2) {
                    Text(schedule.donorName)
                        .font(.headline)
                    Text(schedule.donorEmail)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            AmountFieldDisplay(amount: schedule.amount)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}

private struct AmountFieldDisplay: View {
    let amount: Decimal
    private var formatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        return nf
    }
    var body: some View {
        HStack(spacing: 8) {
            Text(formatter.string(from: amount as NSDecimalNumber) ?? "")
                .font(.headline)
                .padding(.vertical, 10)
                .padding(.leading, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color(UIColor.systemGray6))
                )
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(UIColor.systemGray6))
                    .frame(width: 44, height: 44)
                Image(systemName: "dollarsign")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
        }
    }
}

#Preview {
    RecurringSchedulesListView()
}
