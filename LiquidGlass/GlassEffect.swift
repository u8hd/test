import SwiftUI
import UIKit
import LiquidGlassKit

struct LiquidGlassBackground: UIViewRepresentable {
    var cornerRadius: CGFloat
    var interactive: Bool = true
    var tint: UIColor? = nil

    func makeUIView(context: Context) -> UIView {
        let effect = LiquidGlassEffect(style: .regular, isNative: true)
        effect.isInteractive = interactive
        effect.tintColor = tint

        let view = VisualEffectView(effect: effect)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        view.contentView.isUserInteractionEnabled = false
        view.layer.cornerRadius = cornerRadius
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        return view as UIView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.layer.cornerRadius = cornerRadius
        uiView.layer.cornerCurve = .continuous
    }
}

extension View {
    func liquidGlass(cornerRadius: CGFloat, interactive: Bool = true, tint: Color? = nil) -> some View {
        background(
            LiquidGlassBackground(
                cornerRadius: cornerRadius,
                interactive: interactive,
                tint: tint.map { UIColor($0) }
            )
        )
    }
}
