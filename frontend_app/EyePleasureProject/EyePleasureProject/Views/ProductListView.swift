import SwiftUI

struct ProductListView: View {
    var endpoint: String
    @State private var produtos: [Produto] = []
    @State private var categorias: [String] = []
    @State private var categoriaSelecionada: String = "Todas"
    @State private var isLoading = true

    var produtosFiltrados: [Produto] {
        if categoriaSelecionada == "Todas" {
            return produtos
        } else {
            return produtos.filter { $0.category == categoriaSelecionada }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if !categorias.isEmpty {
                    Picker("Categoria", selection: $categoriaSelecionada) {
                        Text("Todas").tag("Todas")
                        ForEach(categorias, id: \.self) { categoria in
                            Text(categoria).tag(categoria)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                }

                if isLoading {
                    ProgressView("Carregando produtos...")
                        .padding()
                } else if produtosFiltrados.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "tray")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray.opacity(0.5))

                        Text("Nenhum produto encontrado.")
                            .foregroundColor(.gray)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(produtosFiltrados, id: \.id) { produto in
                                NavigationLink(destination: ProductDetailView(produto: produto, produtosRelacionados: produtos)) {
                                    ProductCard(produto: produto)
                                        .padding(.horizontal)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .padding(.top)
            .navigationTitle("Produtos")
            .navigationBarTitleDisplayMode(.large)
            .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 700 : .infinity)
            .onAppear(perform: carregarProdutos)
        }
    }

    func carregarProdutos() {
        guard let url = URL(string: "\(Constants.backendBaseURL)\(endpoint)") else {
            print("❌ URL inválida: \(Constants.backendBaseURL)\(endpoint)")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false
            }

            if let error = error {
                print("❌ Erro ao carregar produtos: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("❌ Nenhum dado recebido")
                return
            }

            do {
                let decoded = try JSONDecoder().decode([Produto].self, from: data)
                DispatchQueue.main.async {
                    self.produtos = decoded
                    self.categorias = Array(Set(decoded.map { $0.category })).sorted()
                }
            } catch {
                print("❌ Falha ao decodificar: \(error.localizedDescription)")
            }
        }.resume()
    }
}
