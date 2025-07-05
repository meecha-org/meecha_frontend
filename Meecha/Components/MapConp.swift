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
    //大阪駅: 34.7025205846408, 135.4960364067425
    //中崎町: 34.70695138831426, 135.50541022329958
    static let ECC = CLLocationCoordinate2D(latitude: 34.70707492346002, longitude: 135.50311626114708)
    static let Osaka = CLLocationCoordinate2D(latitude: 34.7025205846408, longitude: 135.4960364067425)
    static let Nakazaki = CLLocationCoordinate2D(latitude: 34.70695138831426, longitude: 135.50541022329958)
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
                
                //フレンドの位置
                Annotation("フレンドネーム",coordinate: .ECC,anchor: .bottom){
                    FriendMapPinImg(FriendImg: .iconSample)
                }
                Annotation("フレンドネーム",coordinate: .Osaka,anchor: .bottom){
                    FriendMapPinImg(FriendImg: .iconSample1)
                }
                Annotation("フレンドネーム",coordinate: .Nakazaki,anchor: .bottom){
                    FriendMapPinImg(FriendImg: .iconSample2)
                }
            }
            
            //現在地に戻るボタン
            VStack( alignment: .trailing) {
                Spacer()
                HStack {
                    Spacer()
                    LocationButton(position: $position)
                }
                .padding(.trailing, 30)
            }
            .padding(.bottom, 120)
            
        }   // ZStack
    }   //body
}   //View

#Preview {
    MapConp()
}
