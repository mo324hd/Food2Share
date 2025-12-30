import Foundation
import SwiftUI

enum DonationFrequency: String, CaseIterable, Identifiable, Codable {
    case monthly = "Monthly"
    case yearly = "Yearly"
    var id: String { rawValue }
}

struct Supporter: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var email: String

    init(id: UUID = UUID(), name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}

struct RecurringDonation: Identifiable, Codable, Equatable {
    let id: UUID
    var supporter: Supporter
    var amount: Decimal
    var frequency: DonationFrequency
    var nextDate: Date

    init(id: UUID = UUID(), supporter: Supporter, amount: Decimal, frequency: DonationFrequency, nextDate: Date) {
        self.id = id
        self.supporter = supporter
        self.amount = amount
        self.frequency = frequency
        self.nextDate = nextDate
    }
}

final class RecurringDonationsStore: ObservableObject {
    @Published var donations: [RecurringDonation] = []

    // Example seed
    static let example: [RecurringDonation] = {
        let s1 = Supporter(name: "Mohamed Ahmed", email: "mohamedahmed@gmail.com")
        let s2 = Supporter(name: "Yousif Ali", email: "yousifali0@gmail.com")
        return [
            RecurringDonation(supporter: s1, amount: 50, frequency: .yearly, nextDate: .now.addingTimeInterval(60*60*24*365)),
            RecurringDonation(supporter: s2, amount: 200, frequency: .monthly, nextDate: .now.addingTimeInterval(60*60*24*30))
        ]
    }()

    func add(_ donation: RecurringDonation) {
        donations.append(donation)
    }
}

extension Decimal {
    var currencyString: String {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.currencyCode = Locale.current.currency?.identifier ?? "USD"
        return nf.string(from: self as NSDecimalNumber) ?? "$0"
    }
}

extension Date {
    func formattedDate() -> String {
        let df = DateFormatter()
        df.dateStyle = .long
        return df.string(from: self)
    }
}
