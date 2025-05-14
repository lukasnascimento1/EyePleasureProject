//
//  CaptureObjectView.swift
//  EyePleasureProject
//
//  Created by Lukas Soares do Nascimento on 13/05/25.
//

import SwiftUI
import AVFoundation
import RealityKit
import RealityKit.ObjectCapture

struct CaptureObjectView: View {
    @State private var capturedPhotos: [URL] = []
    @State private var isProcessing = false
    @State private var outputModelURL: URL?
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            Text("Captura 3D")
                .font(.largeTitle).bold()

            Button("📷 Tirar Foto") {
                capturePhoto()
            }
            .disabled(isProcessing)

            Text("Fotos capturadas: \(capturedPhotos.count)")

            Button("🎞️ Gerar Modelo 3D") {
                Task { await generateModel() }
            }
            .disabled(capturedPhotos.isEmpty || isProcessing)

            if let outputURL = outputModelURL {
                Button("👀 Ver Modelo") {
                    showModel(url: outputURL)
                }
            }

            if let error = errorMessage {
                Text("Erro: \(error)").foregroundColor(.red)
            }

            if isProcessing {
                ProgressView("Processando modelo...")
            }
        }
        .padding()
    }

    func capturePhoto() {
        // Aqui você pode usar AVCapturePhotoOutput para tirar uma foto e salvá-la em disco
        // Por enquanto: simular foto salva
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".jpg")
        do {
            try Data().write(to: tempURL)
            capturedPhotos.append(tempURL)
        } catch {
            errorMessage = "Erro ao salvar imagem"
        }
    }

    func generateModel() async {
        isProcessing = true
        errorMessage = nil

        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("modelo_resultado.usdz")

        do {
            let session = try PhotogrammetrySession(input: URL(fileURLWithPath: capturedPhotos.first!.deletingLastPathComponent().path))

            let request = PhotogrammetrySession.Request.modelFile(url: outputURL)
            for try await output in session.outputs {
                switch output {
                case .processingComplete:
                    self.outputModelURL = outputURL
                    isProcessing = false
                case .error(let err):
                    errorMessage = err.localizedDescription
                    isProcessing = false
                default: break
                }
            }

            try await session.process(requests: [request])
        } catch {
            errorMessage = error.localizedDescription
            isProcessing = false
        }
    }

    func showModel(url: URL) {
        // Use QuickLook preview
        // ou mostre QuickLook3DViewer(modelURL: url)
    }
}
