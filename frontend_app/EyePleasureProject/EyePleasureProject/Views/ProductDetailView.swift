import SwiftUI
import Foundation


struct ProductDetailView: View {
    let produto: Produto
    let produtosRelacionados: [Produto]
    
    @State private var mostrar3D = false
    @State private var mostrarErro3D = false
    @State private var modeloLocalURL: URL?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let path = produto.imagePath, let url = URL(string: Constants.backendBaseURL + path) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                    } placeholder: {
                        ProgressView()
                            .frame(height: 180)
                    }
                }

                Text(produto.name)
                    .font(.largeTitle)
                    .bold()
                Text("R$ " + produto.price)
                    .font(.title2)
                    .foregroundColor(.green)
                Text(produto.description)
                    .font(.body)
                    .foregroundColor(.secondary)

                Button("🔍 Ver em 3D") {
                    if let url = URL(string: Constants.backendBaseURL + produto.modelPath) {
                        UIApplication.shared.open(url) // Abre no Safari
                    } else {
                        mostrarErro3D = true
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)

                Divider()

                Text("Sugestões para você")
                    .font(.headline)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(produtosRelacionados) { rel in
                            ProductCard(produto: rel)
                                .frame(width: 160)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(produto.name)
        .navigationBarTitleDisplayMode(.inline)

        // ✅ Sheet e Alert agora estão no escopo correto da View
        .sheet(isPresented: $mostrar3D) {
            if let url = modeloLocalURL {
                QuickLook3DViewer(modelURL: url)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .alert("Erro ao carregar modelo 3D", isPresented: $mostrarErro3D) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Não foi possível carregar o modelo. Verifique se o arquivo existe no servidor.")
        }
    }

    // MARK: - Baixar e abrir modelo local
    func baixarModeloEExibir(from url: URL) {
        let task = URLSession.shared.downloadTask(with: url) { localURL, response, error in
            guard let localURL = localURL else {
                DispatchQueue.main.async { mostrarErro3D = true }
                return
            }

            //  Caminho com extensão correta
            let destino = FileManager.default.temporaryDirectory.appendingPathComponent("modelo_temp.usdz")

            //  Substitui se já existir
            try? FileManager.default.removeItem(at: destino)

            do {
                try FileManager.default.copyItem(at: localURL, to: destino)

                DispatchQueue.main.async {
                    self.modeloLocalURL = destino
                    self.mostrar3D = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.mostrarErro3D = true
                }
            }
        }

        task.resume()
    }
}
