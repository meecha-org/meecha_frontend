import Foundation
import CoreLocation

// MARK: - グローバル位置情報監視クラス
class GlobalLocationMonitor: NSObject, CLLocationManagerDelegate {
    
    // シングルトンインスタンス
    static let shared = GlobalLocationMonitor()
    
    private let locationManager = CLLocationManager()
    private var timer: Timer?
    private var currentLocation: CLLocation?
    private var lastData: LocationResponse?
    private var isMonitoring = false
    private let detector = LocationDiffDetector()
    
    private override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // 10メートル移動したら更新
        
        // バックグラウンドでの位置情報取得を許可
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func startMonitoring() {
        guard !isMonitoring else {
            print("既に位置情報監視が開始されています")
            return
        }
        
        // 位置情報の許可をリクエスト
        locationManager.requestAlwaysAuthorization()
        
        // 位置情報の取得開始
        locationManager.startUpdatingLocation()
        
        // 3秒ごとのタイマーを開始
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.logCurrentLocation()
        }
        
        isMonitoring = true
        print("グローバル位置情報監視を開始しました")
    }
    
    func stopMonitoring() {
        guard isMonitoring else {
            print("位置情報監視は既に停止されています")
            return
        }
        
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
        timer = nil
        isMonitoring = false
        print("グローバル位置情報監視を停止しました")
    }
    
    func getCurrentLocation() -> CLLocation? {
        return currentLocation
    }
    
    func isCurrentlyMonitoring() -> Bool {
        return isMonitoring
    }
    
    private func logCurrentLocation() {
        guard let location = currentLocation else {
            print("位置情報が取得できていません")
            return
        }
        
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        print("[\(timestamp)] 緯度: \(location.coordinate.latitude), 経度: \(location.coordinate.longitude), 精度: \(location.horizontalAccuracy)m")
        
        // アクセストークン
        let result = AuthTokenManager.shared.getAccessToken()
                
        // 成功したかどうですか
        if !result.success {
            debugPrint("トークンを取得できませんでした")
            return
        }
        
        // 使用例
        let (response, success) = updateLocation(
            accessToken: result.token!,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        if success {
            print("位置情報更新に成功しました: \(response)")
            
            // 差分を取得する
            let (diff, hasChanges) = detector.detectDifference(newResponse: response!)
            
            // 変更があるか判定
            if hasChanges {
                print("新しいユーザーが追加されました")
                for newUser in diff.added {
                    
                    print("- \(newUser.name) (ID: \(newUser.userid))")
                    LocalNotificationManager.shared.sendCustomNotification(title: "接近通知", body:"\(newUser.name) さんが近くにいます")
                }
                
//                LocalNotificationManager.shared.notifyNewUsers(users: diff.added)
            } else {
                print("新しいユーザーの追加なし")
            }
        } else {
            print("位置情報更新に失敗しました")
        }

    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報取得エラー: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("位置情報の許可が未決定です")
        case .denied, .restricted:
            print("位置情報の許可が拒否されました")
        case .authorizedWhenInUse:
            print("アプリ使用中のみ位置情報が許可されました")
        case .authorizedAlways:
            print("常に位置情報が許可されました")
            if isMonitoring {
                locationManager.startUpdatingLocation()
            }
        @unknown default:
            print("不明な位置情報許可状態です")
        }
    }
}
