//
//  PinDrag.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/17.
//
import Foundation
import SwiftUI
import MapKit
import CoreLocation

struct PinPoint: Identifiable {
    let id = UUID()
    var name: String
    var coord: CLLocationCoordinate2D
}

struct ContentView: View {
    @State var isDraging = false
    @State var modes = MapInteractionModes.all
    @State var dragId = UUID()
    @State var pinList = [PinPoint]()
    
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)    //自分の位置
    
    var body: some View {
        ZStack {
            MapReader { reader in
                Map(position: $position, interactionModes: modes) {
                    ForEach(pinList) { pin in
                        Annotation(pin.name, coordinate: pin.coord) {
                            Image(systemName: "mappin.circle")
                                .resizable()
                                .foregroundStyle(dragId == pin.id ? .main : .gray)
                                .frame(width: 30, height: 30)
                                // 地図上でドラッグする前にピンをタップして選択
                                .onTapGesture {
                                    dragId = pin.id
                                }
                        }
                    }
                }.edgesIgnoringSafeArea(.all)
                
                // 地図上のピンをドラッグ
                .gesture(DragGesture()
                    .onChanged { drag in
                        if isDraging, let ndx = pinList.firstIndex(where: {$0.id == dragId}),
                           let location = reader.convert(drag.location, from: .local) {
                            pinList[ndx].coord = location
                        }
                    }
                )
                // マップモードを変更してピンまたはマップをドラッグできるようにします
                .onChange(of: isDraging) {
                    if isDraging {
                        modes.subtract(.all)
                    } else {
                        dragId = UUID()
                        modes.update(with: .all)
                    }
                }
                // ピンドロップを受け取る
                .dropDestination(for: String.self) { items, location in
                    if let pin = items.first,
                       let coord = reader.convert(location, from: .local) {
                        let pinPoint = PinPoint(name: pin, coord: coord)
                        pinList.append(pinPoint)
                        dragId = pinPoint.id
                        isDraging = true
                    }
                    return true
                }
            }   // MapReader
            
            HStack {
//                // 地図上にドロップするピンのリスト
//                ForEach(["pin-1", "pin-2", "pin-3"], id: \.self) { pin in
//                    Text(pin)
//                        .border(.red)
//                        .draggable(pin)
//                }
                VStack{
                    // マップのドラッグをオン/オフにするボタン
                    Button(action: { isDraging.toggle() }) {
                        VStack {
                            Image(systemName: "move.3d")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(isDraging ? .red : .blue)
                            Text(isDraging ? "Drag on" : "Drag off")
                                .font(.caption)
                                .foregroundColor(isDraging ? .red : .blue)
                        }.frame(width: 80, height: 60)
                    }.buttonStyle(.bordered)
                    Spacer()
                    
                    // ピン追加ボタン
                    HStack{
                        Spacer()
                        Button(action:{
                            
                        }){
                            ZStack{
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 60, height: 60)
                                // 角丸ボーダー
                                    .overlay(
                                        Circle()
                                            .stroke(Color.main, lineWidth: 1)
                                    )
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 26, height: 26)
                                    .foregroundStyle(Color.icon)
                            }
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 30)
                    }
                }   // VStack
                .padding(.bottom, 120)
            }   //
        }   // ZStack
    }   // body
}   // View

#Preview {
    ContentView()
}
