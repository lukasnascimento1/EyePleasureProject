import SwiftUI

struct ProductListView: View {
    let endpoint: String
    @State private var produtos: [Produto] = []
    @State private var erro: String?

    var body: some View {
        List(produtos) { produto in
            NavigationLink(destination: ProductDetailView(produto: produto, produtosRelacionados: [])) {
                ProductCard(produto: produto)
            }
        }
        .onAppear(perform: carregarDados)
        .navigationTitle("Modelos")
        .alert(isPresented: .constant(erro != nil)) {
            Alert(title: Text("Erro"), message: Text(erro ?? "Erro desconhecido"), dismissButton: .default(Text("OK"), action: { erro = nil }))
        }
    }

    func carregarDados() {
        guard let url = URL(string: "\(baseURL)" + endpoint) else {
            erro = "URL inválida."
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { self.erro = error.localizedDescription }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async { self.erro = "Nenhum dado recebido." }
                return
            }

            do {
                let produtos = try JSONDecoder().decode([Produto].self, from: data)
                DispatchQueue.main.async {
                    self.produtos = produtos
                }
            } catch {
                DispatchQueue.main.async {
                    self.erro = "Erro ao decodificar resposta."
                }
            }
        }.resume()
    }
}

//struct ProductListView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ProductListView(endpoint: "/products")
//        }
//    }
//}
