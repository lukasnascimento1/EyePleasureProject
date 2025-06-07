//
//  OnlineMenuAccessView.swift
//  EyePleasureProject
//
//  Created by Lukas Soares do Nascimento on 16/05/25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct OnlineMenuAccessView: View {
    @AppStorage("login") var login: String = ""
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

    var menuURL: String {
        "https://meurestaurante.com/cardapio/\(login)"
    }

    var body: some View {
        VStack(spacing: 32) {
            Text("Acesse seu Cardápio Online")
                .font(.title)
                .bold()

            if let qrImage = generateQRCode(from: menuURL) {
                Image(uiImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .contextMenu {
                        Button("Imprimir QR Code") {
                            printQRCode(qrImage)
                        }
                    }
            } else {
                Text("Erro ao gerar QR Code")
                    .foregroundColor(.red)
            }

            Button("Abrir Cardápio no Navegador") {
                if let url = URL(string: menuURL) {
                    UIApplication.shared.open(url)
                }
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .navigationTitle("Cardápio Online")
    }

    func generateQRCode(from string: String) -> UIImage? {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage,
           let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
        return nil
    }

    func printQRCode(_ image: UIImage) {
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = .photo
        printInfo.jobName = "QR Code"

        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        printController.printingItem = image
        printController.present(animated: true, completionHandler: nil)
    }
}

