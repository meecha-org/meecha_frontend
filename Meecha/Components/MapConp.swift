//
//  MapConp.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/03.
//
import SwiftUI
import MapKit

struct MapConp: View {
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)    //自分の位置
    @StateObject private var friendsModel = FriendModel()
    
    var body: some View {
        ZStack{
            Map(position: $position){
                UserAnnotation(anchor: .bottom) // ユーザーの位置常に表示
                {
                    Image(.userMapPin)
                }
                ForEach(friendsModel.friends){ i in
                    //フレンドの位置
                    Annotation(i.name ,coordinate: i.coordinate ,anchor: .bottom){
                        FriendMapPinImg(FriendImg: "https://k8s-meecha.mattuu.com/auth/assets/c87bb9f9-c224-4e88-9adb-849614275189.png")
                    }
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
        }.task {
            
        }   // ZStack
    }   //body
}   //View

#Preview {
    MapConp()
}
