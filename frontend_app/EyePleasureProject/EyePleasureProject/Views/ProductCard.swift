import SwiftUI

//let baseURL = "http://192.168.86.127:8080" // ✅ Substitua aqui se mudar o IP

struct ProductCard: View {
    let produto: Produto

    var body: some View {
        VStack(alignment: .leading) {
            if let path = produto.imagePath,
               let url = URL(string: baseURL + path) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipped()
                } placeholder: {
                    ProgressView()
                        .frame(height: 180)
                }
            }

            Text(produto.name)
                .font(.headline)
            Text(produto.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
