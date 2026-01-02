import Foundation

struct RecurringSchedule: Identifiable, Equatable, Codable {
    enum Frequency: String, Codable, CaseIterable { case monthly = "Monthly", yearly = "Yearly" }
    let id: UUID
    var donorName: String
    var donorEmail: String
    var amount: Decimal
    var frequency: Frequency
    var startDate: Date
}

final class DonationSchedulesViewModel: ObservableObject {
    @Published var schedules: [RecurringSchedule]

    init(schedules: [RecurringSchedule] = DonationSchedulesViewModel.exampleSchedules()) {
        self.schedules = schedules
    }

    func addSchedule(_ schedule: RecurringSchedule) { schedules.insert(schedule, at: 0) }

    static func exampleSchedules() -> [RecurringSchedule] {
        let now = Date()
        let in30 = Calendar.current.date(byAdding: .day, value: 30, to: now) ?? now
        return [
            RecurringSchedule(id: UUID(), donorName: "Mohamed Ahmed", donorEmail: "mohamedahmed@gmail.com", amount: 50, frequency: .monthly, startDate: now),
            RecurringSchedule(id: UUID(), donorName: "Yousif Ali", donorEmail: "yousifali0@gmail.com", amount: 200, frequency: .monthly, startDate: in30),
            RecurringSchedule(id: UUID(), donorName: "Aisha Khan", donorEmail: "aisha.k@example.com", amount: 120, frequency: .yearly, startDate: now)
        ]
    }
}
