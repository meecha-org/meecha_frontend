//
//  DistanceView.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/17.
//
import SwiftUI
import MapKit

struct DistanceView: View {
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)    //自分の位置

    var body: some View {
        Map(position: $position)
    }
}

#Preview {
    DistanceView()
}
