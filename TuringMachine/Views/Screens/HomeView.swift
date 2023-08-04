import InjectHotReload
import SwiftUI

struct HomeView: View {
    @ObservedObject private var inject = Inject.observer
    @StateObject private var viewModel = HomeViewModel()
    @Default(\.username) var username

    var body: some View {
        VStack {
            Button("View Turing Machine game rules") {
                guard let url = URL(string: "https://turingmachine.info/files/rules/rules_EN.pdf") else { return }
                UIApplication.shared.open(url)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            AsyncImage(url: URL(string: """
            https://www.turingmachine.info/\
            static/media/BOX_EN.80afbd3b950e8e6d9bb8.png
            """)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }

            Spacer()
            Spacer()

            CTAButton(title: username == nil ? "Get Started" : "Play") {
                if username == nil {
                    viewModel.isShowingRegistrationSheet.toggle()
                } else {
                    viewModel.isShowingGameModal.toggle()
                }
            }
        }

        .padding()
        .navigationTitle(username == nil ? "Welcome!" : "Hello, \(username ?? "")!")
        .sheet(isPresented: $viewModel.isShowingRegistrationSheet) {
            RegisterView()
        }
        .fullScreenCover(isPresented: $viewModel.isShowingGameModal, content: {
            GameView()
        })
        .enableInjection()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
