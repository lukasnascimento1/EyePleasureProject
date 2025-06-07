import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss

    @State private var nome = ""
    @State private var email = ""
    @State private var cpf = ""
    @State private var nickname = ""
    @State private var senha = ""

    @State private var status = ""
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                    .padding(.top, 16)

                Text("Criar Nova Conta")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)

                Group {
                    CustomField(icon: "person", placeholder: "Nome", text: $nome)
                    CustomField(icon: "envelope", placeholder: "Email", text: $email, keyboard: .emailAddress)
                    CustomField(icon: "creditcard", placeholder: "CPF", text: $cpf, keyboard: .numberPad)
                    CustomField(icon: "person.fill.questionmark", placeholder: "Apelido (login)", text: $nickname)
                    CustomSecureField(icon: "lock", placeholder: "Senha", text: $senha)
                }

                if isLoading {
                    ProgressView()
                        .padding(.top)
                } else {
                    Button(action: registrarUsuario) {
                        Label("Registrar", systemImage: "checkmark.circle")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }

                if !status.isEmpty {
                    Text(status)
                        .foregroundColor(.gray)
                        .padding(.top)
                }

                Button("Cancelar") {
                    dismiss()
                }
                .foregroundColor(.red)
                .padding(.top, 16)

                Spacer()
            }
            .padding()
            .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 600 : .infinity)
        }
        .navigationTitle("Cadastro")
        .navigationBarTitleDisplayMode(.inline)
    }

    func registrarUsuario() {
        guard let url = URL(string: "\(Constants.backendBaseURL)/auth/register") else {
            status = "❌ URL inválida"
            return
        }

        let usuario: [String: String] = [
            "name": nome,
            "email": email,
            "cpf": cpf,
            "nickname": nickname,
            "psswd": senha
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: usuario) else {
            status = "❌ Erro ao gerar JSON"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        isLoading = true
        status = "Enviando..."

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    status = "❌ Erro: \(error.localizedDescription)"
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    status = "❌ Resposta inválida"
                }
                return
            }

            DispatchQueue.main.async {
                if httpResponse.statusCode == 200 {
                    status = "✅ Usuário cadastrado com sucesso!"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        dismiss()
                    }
                } else if httpResponse.statusCode == 409 {
                    status = "❌ Apelido já em uso."
                } else {
                    status = "❌ Erro ao registrar (código: \(httpResponse.statusCode))"
                }
            }
        }.resume()
    }
}

struct CustomField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            TextField(placeholder, text: $text)
                .keyboardType(keyboard)
                .autocapitalization(.none)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct CustomSecureField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            SecureField(placeholder, text: $text)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}
