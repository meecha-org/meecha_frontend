//
//  PrivatePinData.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/19.
//
import SwiftUI
import Foundation
import MapKit

struct Pin: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    var size: Int
    var selectSize: Int
}

class PrivatePinModel: ObservableObject {
    // Viewに通知するため @Published をつける
        @Published var pins: [Pin] = []
    // 34.70262239561115, 135.49598158093102
    let OsakaStation = CLLocationCoordinate2D(latitude: 34.70262239561115, longitude: 135.49598158093102)
    // 34.435600084799084, 135.2428211410577
    let KIX = CLLocationCoordinate2D(latitude: 34.435600084799084, longitude: 135.2428211410577)

    
    init(){
        //仮データ
        pins = [
//            Pin(coordinate: OsakaStation, size: 50,selectSize: 300  ),
//            Pin(coordinate: KIX, size: 150,selectSize: 300),
        ]
    }
}



