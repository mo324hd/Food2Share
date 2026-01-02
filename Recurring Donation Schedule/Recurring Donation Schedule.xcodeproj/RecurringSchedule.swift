import Foundation

struct RecurringSchedule: Identifiable, Equatable {
    enum Frequency: String, Codable, CaseIterable, Equatable {
        case monthly
        case yearly
    }

    var id: UUID
    var donorName: String
    var donorEmail: String
    var amount: Decimal
    var frequency: Frequency
    var startDate: Date
}
