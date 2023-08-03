import InjectHotReload
import SwiftUI

struct HomeView: View {
    @ObservedObject private var inject = Inject.observer
    @State private var isShowingSheet = false

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
            CTAButton(title: "Get Started") {
                isShowingSheet.toggle()
            }
        }
        .padding()
        .navigationTitle("Welcome! 👋")
        .sheet(isPresented: $isShowingSheet) {
            RegisterView()
        }
        .enableInjection()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
