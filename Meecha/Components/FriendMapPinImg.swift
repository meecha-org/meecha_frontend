import SwiftUI

// 画像キャッシュクラス
class ImageCache: ObservableObject {
    static let shared = ImageCache()
    private var cache: [String: UIImage] = [:]
    private let queue = DispatchQueue(label: "ImageCache", qos: .background)
    
    private init() {}
    
    func getImage(for url: String) -> UIImage? {
        return queue.sync {
            return cache[url]
        }
    }
    
    func setImage(_ image: UIImage, for url: String) {
        queue.async {
            self.cache[url] = image
        }
    }
    
    func hasImage(for url: String) -> Bool {
        return queue.sync {
            return cache[url] != nil
        }
    }
}

struct FriendMapPinImg: View {
    @State var FriendImg: String
    @State private var imageLoadState: ImageLoadState = .loading
    @State private var loadingStartTime: Date?
    @StateObject private var imageCache = ImageCache.shared
    
    enum ImageLoadState {
        case loading
        case loaded(Image)
        case failed(String)
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Image(.friendPin)
            
            VStack(alignment: .center) {
                switch imageLoadState {
                case .loading:
                    // キャッシュされた画像があるかチェック
                    if let cachedImage = imageCache.getImage(for: FriendImg) {
                        Image(uiImage: cachedImage)
                            .resizable()
                            .frame(width: 37, height: 37)
                            .cornerRadius(100)
                            .padding(.top, 2)
                            .padding(.trailing, 1)
                    } else {
                        // キャッシュがない場合のみローディング表示
                        VStack {
                            ProgressView()
                                .frame(width: 20, height: 20)
                            if let startTime = loadingStartTime {
                                let elapsed = Date().timeIntervalSince(startTime)
                                Text("\(String(format: "%.1f", elapsed))s")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(width: 37, height: 37)
                        .padding(.top, 2)
                        .padding(.trailing, 1)
                    }
                    
                case .loaded(let image):
                    image
                        .resizable()
                        .frame(width: 37, height: 37)
                        .cornerRadius(100)
                        .padding(.top, 2)
                        .padding(.trailing, 1)
                        
                case .failed(let errorMessage):
                    VStack(spacing: 2) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                        Text(errorMessage)
                            .font(.system(size: 8))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                    }
                    .frame(width: 37, height: 37)
                    .padding(.top, 2)
                    .padding(.trailing, 1)
                }
                Spacer()
            }
        }
        .frame(width: 50, height: 50)
        .onAppear {
            loadImageWithCache()
        }
        .onChange(of: FriendImg) {
            loadImageWithCache()
        }
    }
    
    private func loadImageWithCache() {
        // まずキャッシュをチェック
        if let cachedImage = imageCache.getImage(for: FriendImg) {
            imageLoadState = .loaded(Image(uiImage: cachedImage))
            debugPrint("✅ FriendMapPinImg: キャッシュから画像取得 - \(FriendImg)")
            return
        }
        
        // キャッシュにない場合のみネットワークからロード
        guard let url = URL(string: FriendImg) else {
            imageLoadState = .failed("無効なURL")
            debugPrint("❌ FriendMapPinImg: 無効なURL - \(FriendImg)")
            return
        }
        
        // すでに読み込み中の場合はスキップ
        if case .loading = imageLoadState, loadingStartTime != nil {
            debugPrint("🔄 FriendMapPinImg: 既に読み込み中 - \(FriendImg)")
            return
        }
        
        imageLoadState = .loading
        loadingStartTime = Date()
        debugPrint("🔄 FriendMapPinImg: 画像読み込み開始 - \(FriendImg)")
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 15.0
        request.setValue("image/*", forHTTPHeaderField: "Accept")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                let loadTime = self.loadingStartTime.map { Date().timeIntervalSince($0) } ?? 0
                
                if let error = error {
                    let nsError = error as NSError
                    var errorMessage = "ネットワークエラー"
                    
                    switch nsError.code {
                    case NSURLErrorTimedOut:
                        errorMessage = "タイムアウト"
                    case NSURLErrorNotConnectedToInternet:
                        errorMessage = "ネット接続なし"
                    case NSURLErrorCannotFindHost:
                        errorMessage = "ホストが見つかりません"
                    case NSURLErrorCannotConnectToHost:
                        errorMessage = "接続できません"
                    default:
                        errorMessage = "エラー: \(nsError.code)"
                    }
                    
                    self.imageLoadState = .failed(errorMessage)
                    debugPrint("❌ FriendMapPinImg: \(errorMessage) (時間: \(String(format: "%.1f", loadTime))s) - \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    let errorMessage = "不正なレスポンス"
                    self.imageLoadState = .failed(errorMessage)
                    debugPrint("❌ FriendMapPinImg: \(errorMessage) (時間: \(String(format: "%.1f", loadTime))s)")
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    let errorMessage = "HTTP: \(httpResponse.statusCode)"
                    self.imageLoadState = .failed(errorMessage)
                    debugPrint("❌ FriendMapPinImg: HTTPエラー \(httpResponse.statusCode) (時間: \(String(format: "%.1f", loadTime))s)")
                    return
                }
                
                guard let data = data, !data.isEmpty else {
                    let errorMessage = "データが空"
                    self.imageLoadState = .failed(errorMessage)
                    debugPrint("❌ FriendMapPinImg: データが空 (時間: \(String(format: "%.1f", loadTime))s)")
                    return
                }
                
                guard let uiImage = UIImage(data: data) else {
                    let errorMessage = "画像変換失敗"
                    self.imageLoadState = .failed(errorMessage)
                    debugPrint("❌ FriendMapPinImg: 画像変換失敗 (時間: \(String(format: "%.1f", loadTime))s)")
                    return
                }
                
                // キャッシュに保存
                self.imageCache.setImage(uiImage, for: self.FriendImg)
                self.imageLoadState = .loaded(Image(uiImage: uiImage))
                debugPrint("✅ FriendMapPinImg: 画像読み込み成功してキャッシュに保存 (時間: \(String(format: "%.1f", loadTime))s) - \(url.absoluteString)")
            }
        }.resume()
    }
}

// さらにシンプルなバージョン（デバッグ情報なし）
struct SimpleFriendMapPinImg: View {
    @State var FriendImg: String
    @State private var image: UIImage?
    @State private var isLoading = false
    @StateObject private var imageCache = ImageCache.shared
    
    var body: some View {
        ZStack(alignment: .center) {
            Image(.friendPin)
            
            VStack(alignment: .center) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 37, height: 37)
                        .cornerRadius(100)
                        .padding(.top, 2)
                        .padding(.trailing, 1)
                } else if isLoading {
                    ProgressView()
                        .frame(width: 20, height: 20)
                        .padding(.top, 2)
                        .padding(.trailing, 1)
                } else {
                    Image(systemName: "person.circle.fill")
                        .frame(width: 37, height: 37)
                        .foregroundColor(.gray)
                        .padding(.top, 2)
                        .padding(.trailing, 1)
                }
                Spacer()
            }
        }
        .frame(width: 50, height: 50)
        .onAppear {
            loadImage()
        }
        .onChange(of: FriendImg) {
            loadImage()
        }
    }
    
    private func loadImage() {
        // キャッシュチェック
        if let cachedImage = imageCache.getImage(for: FriendImg) {
            image = cachedImage
            isLoading = false
            return
        }
        
        guard let url = URL(string: FriendImg) else {
            image = nil
            isLoading = false
            return
        }
        
        // 既に読み込み中の場合はスキップ
        if isLoading { return }
        
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let data = data, let uiImage = UIImage(data: data) {
                    self.imageCache.setImage(uiImage, for: self.FriendImg)
                    self.image = uiImage
                } else {
                    self.image = nil
                }
            }
        }.resume()
    }
}

#Preview {
    FriendMapPinImg(FriendImg: "https://k8s-meecha.mattuu.com/auth/assets/c87bb9f9-c224-4e88-9adb-849614275189.png")
}
