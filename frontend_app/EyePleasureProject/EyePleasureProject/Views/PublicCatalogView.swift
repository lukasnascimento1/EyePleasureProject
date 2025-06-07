import SwiftUI
import Foundation

struct PublicCatalogView: View {
    var body: some View {
        ProductListView(endpoint: "/products/modelos")
            .navigationTitle("Cardápio 3D")
    }
}

struct PublicCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PublicCatalogView()
        }
    }
}
