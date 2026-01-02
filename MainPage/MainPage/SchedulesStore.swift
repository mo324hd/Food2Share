import Foundation
import SwiftUI
import Combine

final class SchedulesStore: ObservableObject {
    static let shared = SchedulesStore()
    @Published var schedules: [RecurringSchedule] = []
}
