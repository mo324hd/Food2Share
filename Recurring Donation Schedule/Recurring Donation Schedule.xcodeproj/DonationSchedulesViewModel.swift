import Foundation
import Combine

final class DonationSchedulesViewModel: ObservableObject {
    @Published var schedules: [RecurringSchedule] = []

    func addSchedule(_ schedule: RecurringSchedule) {
        schedules.append(schedule)
    }
}
