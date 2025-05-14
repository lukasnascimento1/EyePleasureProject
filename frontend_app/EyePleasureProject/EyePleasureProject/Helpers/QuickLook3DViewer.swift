import QuickLook
import SwiftUI

struct QuickLook3DViewer: UIViewControllerRepresentable {
    let modelURL: URL

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        context.coordinator.previewItem = modelURL as NSURL
        return controller
    }

    func updateUIViewController(_ controller: QLPreviewController, context: Context) {}

    class Coordinator: NSObject, QLPreviewControllerDataSource {
        var previewItem: NSURL?

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return previewItem == nil ? 0 : 1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return previewItem!
        }
    }
}
