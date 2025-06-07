import SwiftUI

struct MenuView: View {
    @AppStorage("login") var login: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)

                    Text("Bem-vindo, \(login)")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .padding(.top)

                VStack(spacing: 16) {
                    NavigationLink(destination: QRCodeView(url: "https://seudominio.com/cardapio")) {
                        Label("Ver QR Code do Cardápio", systemImage: "qrcode")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    NavigationLink(destination: ProductListView(endpoint: "/products/usuario/\(login)")) {
                        Label("Ver Meus Produtos", systemImage: "menucard")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    NavigationLink(destination: UploadView()) {
                        Label("Cadastrar Novo Produto", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }

                Spacer()

                Button(action: {
                    login = ""
                }) {
                    Label("Sair", systemImage: "arrow.backward.circle")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.bottom)
            }
            .padding()
            .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 600 : .infinity)
            .navigationTitle("Menu Principal")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
