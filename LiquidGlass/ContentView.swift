import SwiftUI

struct NavItem: Identifiable {
    let id = UUID()
    let title: String
    let systemImage: String
    let path: String
}

struct PressableStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.88 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct ContentView: View {
    @StateObject private var model = WebViewModel()
    @State private var isLoading = true
    @State private var selectedPath = "/discover"
    @Namespace private var glassNamespace

    private let background = Color(red: 18 / 255, green: 18 / 255, blue: 18 / 255)

    private let items: [NavItem] = [
        NavItem(title: "Home", systemImage: "house.fill", path: "/discover"),
        NavItem(title: "Feed", systemImage: "newspaper.fill", path: "/feed"),
        NavItem(title: "Search", systemImage: "magnifyingglass", path: "/search"),
        NavItem(title: "Library", systemImage: "books.vertical.fill", path: "/you/library"),
        NavItem(title: "Download", systemImage: "arrow.down.circle", path: "/download")
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            background.ignoresSafeArea()

            WebView(model: model, isLoading: $isLoading, initialPath: selectedPath)
                .ignoresSafeArea(edges: .bottom)

            if isLoading {
                ProgressView()
                    .controlSize(.large)
                    .tint(Color(red: 1.0, green: 0.33, blue: 0.0))
                    .transition(.opacity.combined(with: .scale))
            }

            navBar
                .padding(.horizontal, 16)
                .padding(.bottom, 6)
        }
        .animation(.easeInOut(duration: 0.25), value: isLoading)
    }

    private var navBar: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                let isSelected = selectedPath == item.path

                Button {
                    withAnimation(.spring(response: 0.38, dampingFraction: 0.72)) {
                        selectedPath = item.path
                    }
                    model.load(path: item.path)
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: item.systemImage)
                            .font(.system(size: 20))
                            .scaleEffect(isSelected ? 1.18 : 1.0)
                            .rotationEffect(.degrees(isSelected ? -4 : 0))

                        Text(item.title)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundStyle(isSelected ? Color.white : Color.white.opacity(0.55))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(.white.opacity(0.16))
                                .matchedGeometryEffect(id: "tabHighlight", in: glassNamespace)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PressableStyle())
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .liquidGlass(cornerRadius: 26)
    }
}

#Preview {
    ContentView()
}
