import SwiftUI
import UniformTypeIdentifiers

// MARK: - File Picker Button
struct FilePickerButton: View {
    let title: String
    @Binding var url: URL?
    var contentTypes: [UTType]

    @State private var isPickerPresented = false

    var body: some View {
        Button(action: {
            isPickerPresented = true
        }) {
            HStack {
                Image(systemName: "doc")
                Text(url?.lastPathComponent ?? title)
                    .lineLimit(1)
            }
            .padding(10)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
        .fileImporter(isPresented: $isPickerPresented, allowedContentTypes: contentTypes) { result in
            switch result {
            case .success(let selectedURL):
                url = selectedURL
            case .failure:
                break
            }
        }
    }
}

// MARK: - MultipartFormDataBuilder
import Foundation

class MultipartFormDataBuilder {
    private let boundary: String
    private var body = Data()

    init(boundary: String) {
        self.boundary = boundary
    }

    func appendText(field: String, value: String) -> Self {
        let textField = """
        --\(boundary)\r\n
        Content-Disposition: form-data; name=\"\(field)\"\r\n
        \r\n
        \(value)\r\n
        """
        if let data = textField.data(using: .utf8) {
            body.append(data)
        }
        return self
    }

    func appendFile(field: String, fileURL: URL, filename: String) -> Self {
        do {
            let fileData = try Data(contentsOf: fileURL)
            let mimeType = mimeTypeForPathExtension(fileURL.pathExtension)

            let fileHeader = """
            --\(boundary)\r\n
            Content-Disposition: form-data; name=\"\(field)\"; filename=\"\(filename)\"\r\n
            Content-Type: \(mimeType)\r\n
            \r\n
            """
            if let headerData = fileHeader.data(using: .utf8) {
                body.append(headerData)
                body.append(fileData)
                body.append("\r\n".data(using: .utf8)!)
            }
        } catch {
            print("❌ Erro ao ler o arquivo \(filename): \(error.localizedDescription)")
        }
        return self
    }

    func build() -> Data {
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }

    private func mimeTypeForPathExtension(_ ext: String) -> String {
        switch ext.lowercased() {
        case "usdz": return "model/vnd.usdz+zip"
        case "jpg", "jpeg": return "image/jpeg"
        case "png": return "image/png"
        default: return "application/octet-stream"
        }
    }
}
