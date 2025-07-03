//
//  MapConp.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/03.
//
import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    //ECC: 34.70707492346002, 135.50311626114708
    static let ECC = CLLocationCoordinate2D(latitude: 34.70707492346002, longitude: 135.50311626114708)
}

struct MapConp: View {
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        ZStack{
            Map(position: $position){
                UserAnnotation(anchor: .bottom) // ユーザーの位置常に表示
                {
                    Image(.userMapPin)
                }
                
                Annotation("フレンドネーム",coordinate: .ECC,anchor: .bottom){
                    FriendMapPin()
                }
                     
                
                    
            }
        }
        
        VStack( alignment: .trailing) {
            Spacer()
            HStack {
                Spacer()
                LocationButton(position: $position)
            }
            .padding(.trailing, 30)
        }
        .padding(.bottom, 120)
    }
}

#Preview {
    MapConp()
}
