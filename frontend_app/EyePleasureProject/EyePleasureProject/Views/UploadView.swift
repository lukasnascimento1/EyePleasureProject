import SwiftUI
import UniformTypeIdentifiers

struct UploadView: View {
    @AppStorage("login") var login: String = ""

    @State private var nome = ""
    @State private var descricao = ""
    @State private var categoria = ""
    @State private var preco = ""
    @State private var tamanho = ""

    @State private var modelURL: URL?
    @State private var imageURL: URL?

    @State private var status = ""
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Novo Produto")
                    .font(.title2).bold()

                TextField("Nome", text: $nome)
                    .textFieldStyle(.roundedBorder)
                TextField("Descrição", text: $descricao)
                    .textFieldStyle(.roundedBorder)
                TextField("Categoria", text: $categoria)
                    .textFieldStyle(.roundedBorder)
                TextField("Preço", text: $preco)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                TextField("Tamanho", text: $tamanho)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)

                FilePickerButton(title: "Selecionar Modelo (.usdz)", url: $modelURL, contentTypes: [.item])
                FilePickerButton(title: "Selecionar Imagem", url: $imageURL, contentTypes: [.image])

                Button("Enviar Produto") {
                    enviarProduto()
                }
                .disabled(isLoading || modelURL == nil || imageURL == nil)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                if isLoading {
                    ProgressView()
                }

                Text(status)
                    .foregroundColor(.gray)
                    .padding()
            }
            .padding()
        }
    }

    func enviarProduto() {
        guard let modelURL = modelURL,
              let imageURL = imageURL,
              let url = URL(string: "http://192.168.86.127:8080/products/criarComArquivo") else {
            status = "❌ Dados ou URLs inválidos"
            return
        }

        guard modelURL.startAccessingSecurityScopedResource(),
              imageURL.startAccessingSecurityScopedResource() else {
            status = "❌ Sem permissão para acessar arquivos"
            return
        }

        defer {
            modelURL.stopAccessingSecurityScopedResource()
            imageURL.stopAccessingSecurityScopedResource()
        }

        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        func appendTextField(_ name: String, value: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        func appendFileField(_ name: String, fileURL: URL, mimeType: String) {
            guard let fileData = try? Data(contentsOf: fileURL) else {
                status = "❌ Erro ao ler o arquivo \(fileURL.lastPathComponent)"
                return
            }

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
        }

        appendTextField("name", value: nome)
        appendTextField("description", value: descricao)
        appendTextField("category", value: categoria)
        appendTextField("price", value: preco)
        appendTextField("size", value: tamanho)
        appendTextField("username", value: login)
        appendFileField("file", fileURL: modelURL, mimeType: "model/vnd.usdz+zip")
        appendFileField("image", fileURL: imageURL, mimeType: "image/png") // ou image/jpeg conforme necessário
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        isLoading = true
        status = "Enviando..."

        URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    status = "❌ Erro: \(error.localizedDescription)"
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    status = httpResponse.statusCode == 200
                        ? "✅ Produto enviado com sucesso!"
                        : "❌ Erro: código \(httpResponse.statusCode)"
                }
            }
        }.resume()
    }
}
