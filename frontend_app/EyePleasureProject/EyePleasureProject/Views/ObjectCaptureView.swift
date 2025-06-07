import SwiftUI

struct ObjectCaptureView: View {
    var onModelGenerated: (URL) -> Void
    var onFailure: (Error) -> Void

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Button(action: { dismiss() }) {
                    Label("Voltar", systemImage: "chevron.left")
                        .font(.body)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding(.leading)

                Spacer()
            }

            Spacer()

            VStack(spacing: 20) {
                Text("Captura 3D indisponível")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Text("Esta função foi desativada. Use um app como RealityScan para gerar seu modelo e envie pelo botão abaixo.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                Button("Fechar") {
                    dismiss()
                }
                .padding()
                .frame(maxWidth: 200)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }

            Spacer()
        }
        .padding()
    }
}
