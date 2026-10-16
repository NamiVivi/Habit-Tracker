import SwiftUI

struct StickerView: View {
    let milestone: Milestone
    let isEarned: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(
                        isEarned
                            ? AnyShapeStyle(LinearGradient(colors: [.yellow.opacity(0.6), .orange.opacity(0.5)],
                                                           startPoint: .topLeading, endPoint: .bottomTrailing))
                            : AnyShapeStyle(Color(.tertiarySystemFill))
                    )
                    .overlay(Circle().strokeBorder(Color.white.opacity(isEarned ? 0.8 : 0), lineWidth: 3))
                    .shadow(color: isEarned ? .orange.opacity(0.35) : .clear, radius: 6, y: 3)
                Text(milestone.sticker)
                    .font(.system(size: 34))
                    .grayscale(isEarned ? 0 : 1)
                    .opacity(isEarned ? 1 : 0.3)
                if !isEarned {
                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .offset(x: 22, y: 22)
                }
            }
            .frame(width: 68, height: 68)

            Text(milestone.title)
                .font(.caption.weight(isEarned ? .semibold : .regular))
                .foregroundStyle(isEarned ? .primary : .secondary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(milestone.title) sticker, \(isEarned ? "earned" : "locked")")
    }
}

#Preview {
    HStack {
        StickerView(milestone: Milestone.all[2], isEarned: true)
        StickerView(milestone: Milestone.all[5], isEarned: false)
    }
}
