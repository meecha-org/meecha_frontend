//
//  FriendData.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/08.
//
import SwiftUI
import Foundation
import MapKit

// Identifiableプロトコル ⇨ 値が一意(ユニーク)であることを保証する
struct FriendData: Identifiable {
    let name: String    // 名前
    let coordinate: CLLocationCoordinate2D      // 座標
    let iconImage: ImageResource
    let id = UUID()     // 識別するためのIDを生成
}

class FriendModel: ObservableObject {
    // Viewに通知するため @Published をつける
        @Published var friends: [FriendData] = []

    init(){
        //仮データ
        friends = [
            FriendData(name: "matumoto", coordinate: .ECC, iconImage: .iconSample),
            FriendData(name: "karen", coordinate: .Osaka, iconImage: .iconSample1),
            FriendData(name: "ryo", coordinate: .Nakazaki, iconImage: .iconSample2),
            FriendData(name: "yuki", coordinate: .Yumesima, iconImage: .iconSample3),
            FriendData(name: "goroka", coordinate: .Kanku,iconImage: .iconSample4),
            FriendData(name: "かれんこん", coordinate: .Kuresaki, iconImage: .iconSample5)
        ]
    }
}

//サンプル位置情報
extension CLLocationCoordinate2D {
    //ECC: 34.70707492346002, 135.50311626114708
    //大阪駅: 34.7025205846408, 135.4960364067425
    //中崎町: 34.70695138831426, 135.50541022329958
    //夢洲駅: 34.65181231111916, 135.38966083275974
    //関空: 34.43586422005164, 135.24303948201475
    //クレ崎(本州最南端): 33.433201772727585, 135.76246515724085
    
    static let ECC = CLLocationCoordinate2D(latitude: 34.70707492346002, longitude: 135.50311626114708)
    static let Osaka = CLLocationCoordinate2D(latitude: 34.7025205846408, longitude: 135.4960364067425)
    static let Nakazaki = CLLocationCoordinate2D(latitude: 34.70695138831426, longitude: 135.50541022329958)
    static let Yumesima = CLLocationCoordinate2D(latitude: 34.65181231111916, longitude: 135.38966083275974)
    static let Kanku = CLLocationCoordinate2D(latitude: 34.43586422005164, longitude: 135.24303948201475)
    static let Kuresaki = CLLocationCoordinate2D(latitude: 33.433201772727585, longitude: 135.76246515724085)
}


