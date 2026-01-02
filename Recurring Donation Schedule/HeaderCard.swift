import SwiftUI

struct HeaderCard: View {
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

#Preview {
    HeaderCard(title: "Preview Title")
}
