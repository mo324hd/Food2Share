import SwiftUI

struct HeaderCard: View {
    var title: String

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.purple.opacity(0.1))
            HStack(spacing: 12) {
                Image(systemName: "heart.circle.fill")
                    .font(.title)
                    .foregroundStyle(.purple)
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text("Set up and manage your recurring giving.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 96)
    }
}

#Preview {
    HeaderCard(title: "Recurring Donations")
}
