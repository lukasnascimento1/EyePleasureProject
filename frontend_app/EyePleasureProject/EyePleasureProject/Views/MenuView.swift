import SwiftUI

struct MenuView: View {
    @AppStorage("login") var login: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Bem-vindo, \(login)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.top)

                NavigationLink(destination: ProductListView(endpoint: "/products/usuario/\(login)")) {
                    Label("Meus Modelos", systemImage: "folder")
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)

                NavigationLink(destination: PublicCatalogView()) {
                    Label("Ver Cardápio Geral", systemImage: "menucard")
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)

                NavigationLink(destination: UploadView()) {
                    Label("Enviar Novo Modelo", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)

                Spacer()

                Button("Sair", role: .destructive) {
                    login = ""
                }
                .padding(.bottom)
            }
            .padding()
            .navigationTitle("Menu Principal")
            .animation(.easeInOut, value: login)
        }
    }
}

//struct MenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuView()
//    }
//}
