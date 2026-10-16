import SwiftUI

struct Celebration: Identifiable {
    let id = UUID()
    let habitName: String
    let habitEmoji: String
    /// Newly reached milestones, in ascending order.
    let milestones: [Milestone]
}

struct CelebrationView: View {
    let celebration: Celebration
    @Environment(\.dismiss) private var dismiss
    @State private var appeared = false

    var body: some View {
        let top = celebration.milestones.last!
        let others = celebration.milestones.dropLast()

        ZStack {
            ConfettiView()

            VStack(spacing: 20) {
                Spacer()
                Text(top.sticker)
                    .font(.system(size: 120))
                    .scaleEffect(appeared ? 1 : 0.2)
                    .rotationEffect(.degrees(appeared ? 0 : -40))

                Text("New sticker unlocked!")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.accentColor)
                    .textCase(.uppercase)

                Text("\(top.title) free from \(celebration.habitName)")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)

                Text(top.message)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                if !others.isEmpty {
                    VStack(spacing: 8) {
                        Text("Also added to your sticker book:")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        HStack {
                            ForEach(others) { milestone in
                                Text(milestone.sticker).font(.title)
                            }
                        }
                    }
                }

                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Keep Going")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding(24)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                appeared = true
            }
        }
        .sensoryFeedback(.success, trigger: appeared)
        .presentationDragIndicator(.visible)
    }
}

struct ConfettiView: View {
    private struct Piece: Identifiable {
        let id = UUID()
        let x = CGFloat.random(in: 0...1)
        let color = [Color.red, .orange, .yellow, .green, .teal, .blue, .purple, .pink].randomElement()!
        let size = CGSize(width: CGFloat.random(in: 6...10), height: CGFloat.random(in: 10...16))
        let spin = Double.random(in: 180...720)
        let drift = CGFloat.random(in: -40...40)
        let duration = Double.random(in: 2.2...3.8)
        let delay = Double.random(in: 0...0.8)
    }

    @State private var pieces = (0..<60).map { _ in Piece() }
    @State private var falling = false

    var body: some View {
        GeometryReader { geo in
            ForEach(pieces) { piece in
                RoundedRectangle(cornerRadius: 2)
                    .fill(piece.color)
                    .frame(width: piece.size.width, height: piece.size.height)
                    .rotationEffect(.degrees(falling ? piece.spin : 0))
                    .position(
                        x: piece.x * geo.size.width + (falling ? piece.drift : 0),
                        y: falling ? geo.size.height + 40 : -40
                    )
                    .animation(.easeIn(duration: piece.duration).delay(piece.delay), value: falling)
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .onAppear { falling = true }
    }
}

#Preview {
    CelebrationView(celebration: Celebration(
        habitName: "Smoking",
        habitEmoji: "🚬",
        milestones: Array(Milestone.all.prefix(3))
    ))
}
