import SwiftUI
import InjectHotReload

struct HomeView: View {
    @ObservedObject private var inject = Inject.observer

    var body: some View {
        VStack {
            Button("View Turing Machine gamer rules here") {
                guard let url = URL(string: "https://turingmachine.info/files/rules/rules_EN.pdf") else { return }
                UIApplication.shared.open(url)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 30)
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
            CTAButton(title: "Get Started") {}
        }
        .padding()
        .navigationTitle("Welcome! 👋")
        .enableInjection()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
