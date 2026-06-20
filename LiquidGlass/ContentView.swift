import SwiftUI

struct NavItem: Identifiable {
    let id = UUID()
    let title: String
    let systemImage: String
    let path: String
}

struct ContentView: View {
    @StateObject private var model = WebViewModel()
    @State private var isLoading = true
    @State private var selectedPath = "/discover"

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
            }

            navBar
                .padding(.horizontal, 16)
                .padding(.bottom, 6)
        }
    }

    private var navBar: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                Button {
                    selectedPath = item.path
                    model.load(path: item.path)
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: item.systemImage)
                            .font(.system(size: 20))
                        Text(item.title)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundStyle(selectedPath == item.path ? Color.white : Color.white.opacity(0.6))
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .liquidGlass(.regular, in: RoundedRectangle(cornerRadius: 26, style: .continuous))
    }
}

#Preview {
    ContentView()
}
