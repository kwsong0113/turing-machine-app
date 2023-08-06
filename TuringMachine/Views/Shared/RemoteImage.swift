import SwiftUI

struct RemoteImage<Content: View>: View {
    @ObservedObject var imageLoader: ImageLoader
    var content: Content

    init(url: String, @ViewBuilder placeholder: @escaping () -> Content) {
        content = placeholder()
        imageLoader = ImageLoader(url: url)
    }

    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            content
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private var url: String
    private var task: URLSessionDataTask?

    init(url: String) {
        self.url = url
        loadImage()
    }

    private func loadImage() {
        if let cachedImage = ImageCache.shared.get(forKey: url) {
            image = cachedImage
            return
        }

        guard let url = URL(string: url) else { return }

        task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data, error == nil else { return }

            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.image = image
                if let image {
                    ImageCache.shared.set(image, forKey: self.url)
                }
            }
        }
        task?.resume()
    }
}
