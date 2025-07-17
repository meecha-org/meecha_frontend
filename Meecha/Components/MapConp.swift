//
//  MapConp.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/03.
//
import SwiftUI
import MapKit

struct MapConp: View {
    let gradient = LinearGradient(gradient: Gradient(colors: [.clear, .bg]), startPoint: .top, endPoint: .center)   // フッター背景
    let headerBg = LinearGradient(gradient: Gradient(colors: [.bg, .clear]), startPoint: .center, endPoint: .bottom)    //ヘッダー背景
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
                        FriendMapPinImg(FriendImg: "https://k8s-meecha.mattuu.com/auth/assets/\(i.id).png")
                    }
                }   // ForEach
            }.task {
                GlobalLocationMonitor.shared.locationUpdateCallback = { response in
                    debugPrint("location response: \(response)")
                    
                    // near が存在する時
                    if response.near.count > 0 || response.removed.count > 0 {
                        // 存在する時
                        // 全て削除する
                        friendsModel.friends.removeAll()
                        
                        response.near.forEach { friend in
                            // 位置情報
                            let locationData = CLLocationCoordinate2D(latitude: friend.latitude, longitude: friend.longitude)
                            
                            // フレンド情報を追加する
                            friendsModel.friends.append(FriendData(name: "", coordinate: locationData, iconImage: .friendPin, id: friend.userid))
                        }
                    }
                }
                
            }   // map
            VStack{
                Rectangle()
                    .fill(headerBg)
                    .frame(maxWidth: .infinity, maxHeight: 130)
                Spacer()
                Rectangle()
                    .fill(gradient)
                    .frame(maxWidth: .infinity, maxHeight: 130)
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
        }
        .edgesIgnoringSafeArea(.all)
    }   //body
}   //View

#Preview {
    MapConp()
}
