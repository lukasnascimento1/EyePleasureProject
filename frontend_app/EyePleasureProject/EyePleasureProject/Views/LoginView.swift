import SwiftUI

struct LoginView: View {
    @AppStorage("login") var login: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showRegister = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .padding(.bottom, 16)

                Text("Bem-vindo ao EyePleasure")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                GroupBox(label: Label("Entrar na conta", systemImage: "person.crop.circle")) {
                    VStack(spacing: 16) {
                        inputField(icon: "person", placeholder: "Usuário", text: $username)
                        secureField(icon: "lock", placeholder: "Senha", text: $password)
                    }
                    .padding(.vertical, 8)
                }

                Button(action: {
                    login = username // Simula autenticação
                }) {
                    Label("Entrar", systemImage: "arrow.right.circle")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(username.isEmpty || password.isEmpty)

                // 🔸 Botão Criar Conta
                Button(action: {
                    showRegister = true
                }) {
                    Label("Criar Conta", systemImage: "person.badge.plus")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, -12)

                Spacer()
            }
            .padding()
            .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 500 : .infinity)
            .sheet(isPresented: $showRegister) {
                NavigationStack {
                    RegisterView()
                }
            }
        }
    }

    func inputField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            TextField(placeholder, text: text)
                .autocapitalization(.none)
                .textInputAutocapitalization(.never)
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }

    func secureField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            SecureField(placeholder, text: text)
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}
