import SwiftUI

enum GlassStyle {
    case regular
    case interactive
    case tinted(Color)

    var material: Material {
        switch self {
        case .interactive:
            return .thinMaterial
        default:
            return .ultraThinMaterial
        }
    }

    var tint: Color? {
        switch self {
        case .tinted(let color):
            return color
        default:
            return nil
        }
    }
}

extension View {
    func liquidGlass<S: Shape>(_ style: GlassStyle = .regular, in shape: S) -> some View {
        modifier(LiquidGlassModifier(shape: shape, style: style))
    }
}

private struct LiquidGlassModifier<S: Shape>: ViewModifier {
    let shape: S
    let style: GlassStyle

    func body(content: Content) -> some View {
        content.background(
            ZStack {
                shape.fill(style.material)

                if let tint = style.tint {
                    shape.fill(tint.opacity(0.3)).blendMode(.overlay)
                }

                shape.stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.55), .white.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
            }
        )
    }
}
