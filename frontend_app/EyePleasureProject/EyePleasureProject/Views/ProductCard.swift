import SwiftUI
import Foundation

struct ProductCard: View {
    var produto: Produto

    var body: some View {
        HStack(spacing: 16) {
            if let path = produto.imagePath,
               let url = URL(string: Constants.backendBaseURL + path) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 80, height: 80)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    case .failure:
                        Color.red.opacity(0.3)
                            .frame(width: 80, height: 80)
                            .overlay(Image(systemName: "xmark.circle"))
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(produto.name)
                    .font(.headline)

                Text(produto.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                HStack(spacing: 8) {
                    Text("R$ \(produto.price)")
                        .font(.subheadline.bold())
                        .foregroundColor(.green)

                    Text(produto.category)
                        .font(.caption2)
                        .padding(4)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(6)
                }
            }

            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
