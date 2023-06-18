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
            // Phases define discrete states that are
            // provided to a view one at a time.
            // Animation is performed on the changes between the states.
            // All properties specified for a phase are animated concurrently.
            // When all the animations for a phase complete,
            // animations for the next phase begins.
            // By default this continues indefinitely.
            // A trigger can be used to only run through the phases
            // one time each time the trigger value changes.
            //
            // Keyframes support animating property changes independently.
            // Each "track" of keyframes specifies the times
            // at which to modify a specific property.
            // There can be any number of tracks with different timings,
            // one for each property whose changes should be animated.
            // Keyframes can animate any property
            // that conforms to the Animatable protocol.

            /*
             KeyframeAnimator(
                 initialValue: LogoAnimationValues(),
                 trigger: runPlan
             ) { values in
                 LogoField(color: color, isFocused: isFocused)
                     .scaleEffect(values.scale)
                     .rotationEffect(values.rotation, anchor: .bottom)
                     .offset(y: values.verticalTranslation)
             } keyframes: { _ in
                 KeyframeTrack(\.verticalTranslation) {
                     SpringKeyframe(30, duration: 0.25, spring: smooth)
                     CubicKeyframe(-120, duration: 0.3)
                     CubicKeyframe(-120, duration: 0.5)
                     CubicKeyframe(10, duration: 0.3)
                     CubicKeyframe(0, spring: .bouncy)
                 }
                 // KeyframeTrack(\.scale) { ... }
                 // KeyframeTrack(\.rotation) { ... }
             }
             */
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

            // See MapKit mapCameraKeyframeAnimator for animation changes
            // to the centerCoordinate, heading, and distance in a Map camera.

            // See KeyframeTimeline to evaluate a set of KeyframeTrack instances
            // at a given time within the longest duration.

            Button("Trigger") { clickCount += 1 }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
