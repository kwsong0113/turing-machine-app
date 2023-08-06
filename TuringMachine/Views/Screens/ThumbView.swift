import InjectHotReload
import SwiftUI

struct ThumbView: View {
    @ObservedObject private var inject = Inject.observer
    @EnvironmentObject var gameViewModel: GameViewModel
    @StateObject var thumbViewModel = ThumbViewModel()
    @State var showAnimation = false

    var body: some View {
        VStack(spacing: 20) {
            if showAnimation {
                Picker("Difficulty", selection: $thumbViewModel.isThumbUp) {
                    ForEach([true, false], id: \.self) {
                        Image(systemName: $0 ? "hand.thumbsup" : "hand.thumbsdown")
                    }
                }
                .pickerStyle(.segmented)
                .disabled(thumbViewModel.isDone)
                .transition(.move(edge: .bottom))
                if thumbViewModel.isThumbUp {
                    GroupBox {
                        ThreeDigitPicker(digits: $thumbViewModel.digits)
                            .disabled(thumbViewModel.isDone)
                    } label: {
                        Text("Enter the code")
                    }
                    .transition(.move(edge: .bottom))
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Point Your Thumb")
        .navigationBarItems(trailing: Group {
            if thumbViewModel.isDone {
                HStack(spacing: 6) {
                    Text("Waiting for the other user")
                        .font(.footnote)
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                    ProgressView()
                }
            } else {
                Button("Submit") {
                    if thumbViewModel.isThumbUp {
                        gameViewModel.sendThumbUpMessage(num: thumbViewModel.code)
                    } else {
                        gameViewModel.sendThumbDownMessage()
                    }
                    thumbViewModel.isDone.toggle()
                }
            }
        })
        .onAppear {
            withAnimation {
                showAnimation.toggle()
            }
        }
        .enableInjection()
    }
}

struct ThumbView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ThumbView()
        }
        NavigationView {
            ThumbView(thumbViewModel: .init(isDone: true))
        }
        .previewDisplayName("Thumb View - Loading")
    }
}
