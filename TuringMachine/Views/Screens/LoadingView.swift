import SwiftUI

struct LoadingView: View {
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            ProgressView().progressViewStyle(.circular)
            Text(message + "...")
                .font(.title3)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(message: "Loading")
    }
}
