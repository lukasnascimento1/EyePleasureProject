
import SwiftUI
import Foundation
import UniformTypeIdentifiers

struct UploadView: View {
    @AppStorage("login") var login: String = ""
    @State private var modelURL: URL?
    @State private var showForm = true
    @State private var useCapture = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            UploadFormView(
                modelURL: $modelURL,
                useCapture: useCapture,
                onClose: {
                    dismiss()
                }
            )
            .navigationTitle("Cadastrar Produto")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
