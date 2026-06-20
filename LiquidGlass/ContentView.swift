import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.33, blue: 0.0),
                    Color(red: 1.0, green: 0.53, blue: 0.0),
                    Color(red: 0.10, green: 0.10, blue: 0.18)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 12) {
                Text("🎧")
                    .font(.system(size: 56))

                Text("Soundcloud Liquid Glass")
                    .font(.title2.weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)

                Text("Olá, mundo!")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.92))

                Text("Edite ContentView.swift para começar a construir.")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.75))
                    .padding(.top, 4)
            }
            .padding(.vertical, 40)
            .padding(.horizontal, 28)
            .frame(maxWidth: 360)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .strokeBorder(.white.opacity(0.35), lineWidth: 1)
            )
            .padding(24)
        }
    }
}

#Preview {
    ContentView()
}
