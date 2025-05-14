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
        VStack(spacing: 16) {
            Text("Criar Conta")
                .font(.title)
                .bold()

            TextField("Nome", text: $nome)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("CPF", text: $cpf)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Apelido (login)", text: $nickname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Senha", text: $senha)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if isLoading {
                ProgressView()
            } else {
                Button("Registrar") {
                    registrarUsuario()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }

            Text(status)
                .foregroundColor(.gray)

            Button("Cancelar") {
                dismiss()
            }
            .padding(.top, 12)
        }
        .padding()
        .navigationTitle("Cadastro")
    }

    func registrarUsuario() {
        guard let url = URL(string: "\(baseURL)/auth/register") else {
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

//#Preview {
//    RegisterView()
//}
