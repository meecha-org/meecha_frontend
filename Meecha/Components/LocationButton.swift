import SwiftUI
import MapKit

struct LocationButton: View {
    
    @Binding var position: MapCameraPosition

    var body: some View {
        
        Button {
            position = .userLocation(fallback: .automatic)
        } label: {
            Label("ふるさと",systemImage: "location.circle")
        }
    }
}
