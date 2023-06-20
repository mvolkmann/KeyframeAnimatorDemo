import SwiftUI

struct MyView: View {
    var body: some View {
        VStack {
            Image(systemName: "heart.fill")
                .imageScale(.large)
                .foregroundStyle(.red)
            Text("Love It!")
        }
        .padding()
        .border(.red, width: 5)
    }
}

enum MyPhase: CaseIterable {
    case initial, move, scale

    var foregroundStyle: Color {
        switch self {
        case .initial: .black
        case .move, .scale: .red
        }
    }

    var scale: Double {
        switch self {
        case .initial: 1
        case .move, .scale: 2
        }
    }

    var verticalOffset: CGSize {
        switch self {
        case .initial: CGSize(width: 0, height: 0)
        case .move, .scale: CGSize(width: 0, height: -64)
        }
    }
}

struct AnimationValues {
    var scale = 1.0
    var verticalStretch = 1.0
    var verticalTranslation = 0.0
    var angle = Angle.zero
}

// See https://www.google.com/search?client=safari&rls=en&q=wwdc+2023+keyframe+animation&ie=UTF-8&oe=UTF-8
struct ContentView: View {
    @State private var clickCount = 0

    var body: some View {
        VStack {
            MyView()
                /*
                 // This demonstrates basic use of phaseAnimator.
                 // The first argument specifies an array of values
                 // to be used as the values of the closure phase argument.
                 .phaseAnimator([false, true]) { content, phase in
                     // This cycles the opacity between two values.
                     content
                         .opacity(phase ? 1.0 : 0.2)
                         .foregroundStyle(phase ? .red : .primary)
                 } animation: { _ in
                     // This overrides the default animation timing.
                     // Can have a different animation for each phase.
                     .easeInOut(duration: 1.0)
                 }
                 */

                /*
                  // This demonstrates more advanced use of phaseAnimator.
                 .phaseAnimator(
                     MyPhase.allCases,
                     trigger: clickCount
                 ) { content, phase in
                     content
                         .foregroundStyle(phase.foregroundStyle)
                         .offset(phase.verticalOffset)
                         .scaleEffect(phase.scale)
                 } animation: { phase in
                     switch phase {
                     case .initial: .smooth
                     case .move: .easeInOut(duration: 0.3)
                     case .scale: .spring(duration: 0.3, bounce: 0.7)
                     }
                 }
                 */

                .keyframeAnimator(
                    initialValue: AnimationValues(),
                    trigger: clickCount
                ) { content, value in
                    content
                        .rotationEffect(value.angle)
                        .scaleEffect(value.scale)
                        .scaleEffect(y: value.verticalStretch)
                        .offset(y: value.verticalTranslation)
                } keyframes: { _ in
                    KeyframeTrack(\.angle) {
                        CubicKeyframe(.zero, duration: 0.58)
                        CubicKeyframe(.degrees(16), duration: 0.125)
                        CubicKeyframe(.degrees(-16), duration: 0.125)
                        CubicKeyframe(.degrees(16), duration: 0.125)
                        CubicKeyframe(.zero, duration: 0.125)
                    }

                    KeyframeTrack(\.verticalStretch) {
                        CubicKeyframe(1.0, duration: 0.1)
                        CubicKeyframe(0.6, duration: 0.15)
                        CubicKeyframe(1.5, duration: 0.1)
                        CubicKeyframe(1.05, duration: 0.15)
                        CubicKeyframe(1.0, duration: 0.88)
                        CubicKeyframe(0.8, duration: 0.1)
                        CubicKeyframe(1.04, duration: 0.4)
                        CubicKeyframe(1.0, duration: 0.22)
                    }

                    KeyframeTrack(\.scale) {
                        LinearKeyframe(1.0, duration: 0.36)
                        SpringKeyframe(1.5, duration: 0.8, spring: .bouncy)
                        SpringKeyframe(1.0, spring: .bouncy)
                    }

                    KeyframeTrack(\.verticalTranslation) {
                        LinearKeyframe(0.0, duration: 0.1)
                        SpringKeyframe(20.0, duration: 0.15, spring: .bouncy)
                        SpringKeyframe(-60.0, duration: 1.0, spring: .bouncy)
                        SpringKeyframe(0.0, spring: .bouncy)
                    }
                    // Also see MoveKeyframe.
                }

            Button("Trigger") { clickCount += 1 }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
