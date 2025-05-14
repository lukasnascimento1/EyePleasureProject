//
//  CaptureSessionView.swift
//  EyePleasureProject
//
//  Created by Lukas Soares do Nascimento on 13/05/25.
//

struct CaptureSessionView: View {
    @State private var showCamera = false
    @State private var capturedImages: [UIImage] = []

    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(capturedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                    }
                }
            }

            Button("📸 Capturar Foto") {
                showCamera = true
            }
            .padding()
            .sheet(isPresented: $showCamera) {
                ImagePicker(images: $capturedImages)
            }

            Button("⬆️ Enviar para Processamento") {
                // Enviar imagens para backend ou salvar localmente para uso com Object Capture
            }
            .disabled(capturedImages.isEmpty)
        }
        .padding()
    }
}

