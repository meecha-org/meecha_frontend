//
//  LocationManager.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/03.
//
import Foundation
import MapKit
                       
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
  // CLLocationManager()で位置情報を取得
  let manager = CLLocationManager()
  // MKCoordinateRegion()は範囲を指定する
  @Published var region = MKCoordinateRegion()
  
  override init() {
    // NSObjectを初期化
    super.init()
    // 位置が変わった時その情報を自分で受け取る
    manager.delegate = self
    // 位置情報を取得するための許可
    manager.requestWhenInUseAuthorization()
    // 正確な位置を取得
    manager.desiredAccuracy = kCLLocationAccuracyBest
    // 2メートルごとに位置を更新
    manager.distanceFilter = 2
    // 位置情報が変わるたびに情報をうけとれるように
    manager.startUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locations.last.map {
      let center = CLLocationCoordinate2D(
        latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude
      )
      
      region = MKCoordinateRegion(
        center: center,
        latitudinalMeters: 100.0,
        longitudinalMeters: 100.0
      )
    }
  }
}

