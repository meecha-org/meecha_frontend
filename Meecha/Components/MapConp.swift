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
    @State var position: MapCameraPosition = .automatic //
    
    @ObservedObject var manager = LocationManager()
      
    @State var trackingMode = MapUserTrackingMode.follow
    
    var body: some View {
        Map(// 場所の範囲を決める
            coordinateRegion: $manager.region,
            // 自分のいる場所を地図に表示するか
            showsUserLocation: true,
            // 歩いてる時地図の中心を変えるか
            userTrackingMode: $trackingMode)
//            Marker("ECC", systemImage: "train.side.front.car", coordinate: .ECC)
//                .tint(.blue)
    }
}

#Preview {
    MapConp()
}
