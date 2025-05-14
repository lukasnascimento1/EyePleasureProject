import SwiftUI
import QuickLook

struct ModelPreviewView: View {
    let modelURL: URL

    var body: some View {
        QuickLookPreview(url: modelURL)
            .edgesIgnoringSafeArea(.all)
    }
}

struct QuickLookPreview: UIViewControllerRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: QLPreviewController, context: Context) {}

    class Coordinator: NSObject, QLPreviewControllerDataSource {
        let parent: QuickLookPreview

        init(_ parent: QuickLookPreview) {
            self.parent = parent
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            parent.url as NSURL
        }
    }
}

//#Preview {
//    ModelPreviewView(modelURL: URL(string: "https://example.com/meumodelo.usdz")!)
//}
