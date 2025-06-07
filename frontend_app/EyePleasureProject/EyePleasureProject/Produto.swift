import Foundation

struct Produto: Identifiable, Decodable {
    let id: Int
    let name: String
    let description: String
    let category: String
    let price: String
    let modelPath: String
    let imagePath: String?
}
