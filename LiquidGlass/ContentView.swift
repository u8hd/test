import SwiftUI

struct ContentView: View {
    @State private var isLoading = true

    var body: some View {
        ZStack {
            WebView(url: URL(string: "https://soundcloud.com")!, isLoading: $isLoading)
                .ignoresSafeArea(edges: .bottom)

            if isLoading {
                ProgressView()
                    .controlSize(.large)
                    .tint(Color(red: 1.0, green: 0.33, blue: 0.0))
            }
        }
    }
}

#Preview {
    ContentView()
}
