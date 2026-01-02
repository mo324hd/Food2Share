import SwiftUI

struct RecurringSchedule: Identifiable, Hashable {
    let id = UUID()
    var supporterName: String
    var supporterEmail: String
    var amountBHD: Double
    var startDate: Date
}

struct SchedulesHomeView: View {
    @EnvironmentObject var store: SchedulesStore
    @State private var showingCreate = false

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(
                            LinearGradient(colors: [.brandAccent, .brandPrimary.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                        .frame(height: 120)
                        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Recurring Donations")
                            .font(.system(.title2, design: .rounded).weight(.semibold))
                            .foregroundColor(.white)
                        Text("Set up automatic donation schedules")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(Color.white.opacity(0.9))
                    }
                    .padding(.horizontal)
                }

                List {
                    Section(header: Text("Examples")) {
                        exampleRow(title: "Monthly support", subtitle: "BHD 10.00 • 1st of every month")
                        exampleRow(title: "Community fund", subtitle: "BHD 5.00 • 15th of every month")
                        exampleRow(title: "Education aid", subtitle: "BHD 20.00 • 1st of every month")
                    }

                    Section {
                        Button(action: { showingCreate = true }) {
                            Text("Create recurring schedule")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(RoundedProminentButtonStyle())
                    }

                    if !store.schedules.isEmpty {
                        Section(header: Text("Your Recurring Schedules")) {
                            ForEach(store.schedules) { schedule in
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(Color.brandAccent.opacity(0.2))
                                        .frame(width: 36, height: 36)
                                        .overlay(Text(initials(from: schedule.supporterName)).font(.system(.subheadline, design: .rounded).weight(.semibold)).foregroundColor(.brandAccent))

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(schedule.supporterName)
                                            .font(.system(.body, design: .rounded).weight(.semibold))
                                        Text("BHD \(schedule.amountBHD, specifier: "%.2f") • \(formattedDate(schedule.startDate))")
                                            .font(.system(.footnote, design: .rounded))
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                .listRowBackground(Color(.secondarySystemGroupedBackground))
                            }
                            .onDelete(perform: delete)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                }
            }
            .sheet(isPresented: $showingCreate) {
                NavigationView {
                    CreateRecurringScheduleView { newSchedule in
                        store.schedules.append(newSchedule)
                    }
                    .navigationBarTitleDisplayMode(.inline)
                }
                .tint(.brandPrimary)
            }
        }
        .tint(.brandPrimary)
    }

    private func exampleRow(title: String, subtitle: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.body, design: .rounded).weight(.semibold))
                Text(subtitle)
                    .font(.system(.footnote, design: .rounded))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.brandAccent.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.brandAccent.opacity(0.15), lineWidth: 1)
                )
        )
    }

    private func delete(at offsets: IndexSet) {
        store.schedules.remove(atOffsets: offsets)
    }

    private func initials(from name: String) -> String {
        let parts = name.split(separator: " ")
        let initials = parts.prefix(2).compactMap { $0.first }.map { String($0) }.joined()
        return initials.isEmpty ? "S" : initials
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
}

#Preview {
    SchedulesHomeView()
}

struct RoundedProminentButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.headline, design: .rounded))
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.brandPrimary)
                    .opacity(configuration.isPressed ? 0.8 : 1.0)
            )
            .foregroundColor(.white)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension Color {
    static var brandPrimary: Color { Color(red: 0.29, green: 0.141, blue: 0.616) } // 4A249D
    static var brandAccent: Color { Color(red: 0.729, green: 0.612, blue: 0.996) } // BA9CFE

    private func fallback(_ color: Color) -> Color {
        // If the named color doesn’t exist in assets, return a fallback
        #if canImport(UIKit)
        if UIColor(self).cgColor.alpha == 0 { return color }
        #endif
        return self
    }
}
