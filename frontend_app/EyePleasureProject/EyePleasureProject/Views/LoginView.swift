import SwiftUI

struct LoginView: View {
    @AppStorage("login") var login: String = ""
    @State private var nickname = ""
    @State private var senha = ""
    @State private var erro: String?
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                
                // Ícone do app centralizado no topo
                Image("MainProjectIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.top, 40)
                
                Text("EyePleasure")
                    .foregroundColor(.accentColor)
                    .padding()
                    .background(Color.primaryColor)

                VStack(spacing: 16) {
                    TextField("Nickname", text: $nickname)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    SecureField("Senha", text: $senha)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Button(action: autenticar) {
                        Text("Entrar")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }

                NavigationLink("Criar nova conta", destination: RegisterView())
                    .foregroundColor(.white)
                    .padding(.top, 10)

                if let erro = erro {
                    Text(erro)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }

    func autenticar() {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            erro = "URL inválida"
            return
        }

        let usuario = ["nickname": nickname, "psswd": senha]
        print("Tentando login com \(nickname) / \(senha)")
        print("Enviando requisição para \(url)")
        print("Dados: \(usuario)")
        guard let jsonData = try? JSONSerialization.data(withJSONObject: usuario) else {
            erro = "Erro ao codificar JSON"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        isLoading = true
        erro = nil

        URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, _ in
            DispatchQueue.main.async {
                isLoading = false

                if let httpResponse = response as? HTTPURLResponse {
                    print("Status code: \(httpResponse.statusCode)")
                    if httpResponse.statusCode == 200 {
                        login = nickname
                    } else {
                        erro = "Erro no servidor: código \(httpResponse.statusCode)"
                    }
                }
            }
        }.resume()
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
