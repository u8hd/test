import SwiftUI
import WebKit

final class WebViewModel: ObservableObject {
    weak var webView: WKWebView?

    func load(path: String) {
        guard let webView, let url = URL(string: "https://soundcloud.com" + path) else { return }
        webView.load(URLRequest(url: url))
    }

    func search(query: String) {
        guard let webView else { return }
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: "https://soundcloud.com/search?q=\(encoded)") else { return }
        webView.load(URLRequest(url: url))
    }
}

struct WebView: UIViewRepresentable {
    @ObservedObject var model: WebViewModel
    @Binding var isLoading: Bool
    let initialPath: String

    static let injectedJS = """
    (function() {
      if (location.hostname.indexOf('soundcloud.com') === -1) { return; }
      var css = 'html, body { background-color: #121212 !important; } .NavBar_NavBarList__3McZ5 { display: none !important; } .SearchBar_SearchBarContainer__1eIv_ { display: none !important; }';
      var style = document.createElement('style');
      style.textContent = css;
      (document.head || document.documentElement).appendChild(style);
      window.__scBlur = function() {
        var tries = 0;
        var t = setInterval(function() {
          var a = document.activeElement;
          if (a && (a.tagName === 'INPUT' || a.tagName === 'TEXTAREA')) { a.blur(); }
          if (++tries > 14) { clearInterval(t); }
        }, 100);
      };
      if (location.pathname.indexOf('/search') === 0) { window.__scBlur(); }
    })();
    """

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let controller = WKUserContentController()
        controller.addUserScript(
            WKUserScript(source: Self.injectedJS, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        )

        let config = WKWebViewConfiguration()
        config.userContentController = controller
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 18 / 255, green: 18 / 255, blue: 18 / 255, alpha: 1)
        webView.scrollView.backgroundColor = UIColor(red: 18 / 255, green: 18 / 255, blue: 18 / 255, alpha: 1)
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"

        model.webView = webView

        if let url = URL(string: "https://soundcloud.com" + initialPath) {
            webView.load(URLRequest(url: url))
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        let parent: WebView
        private var hasFinishedFirstLoad = false

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            if !hasFinishedFirstLoad {
                parent.isLoading = true
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
            hasFinishedFirstLoad = true
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
            hasFinishedFirstLoad = true
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
            hasFinishedFirstLoad = true
        }
    }
}
