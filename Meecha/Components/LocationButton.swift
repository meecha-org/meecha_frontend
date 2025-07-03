//
//  LocationButton.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/03.
//

import SwiftUI
import MapKit

struct LocationButton: View {

    @Binding var position: MapCameraPosition    //

    var body: some View {
        
        
        Button(action:{
            position = .userLocation(fallback: .automatic)
        }){
            //現在地表示なら塗りつぶしアイコン
            ZStack(alignment: .center){
                if(position == .userLocation(fallback: .automatic)){
                    Image(.locationFill)
                }else{
                    Image(.location)
                }
                
            }
        }
    }
}
