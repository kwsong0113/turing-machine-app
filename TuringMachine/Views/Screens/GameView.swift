import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameStore: GameStore

    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            CTAButton(title: "Error") {
                gameStore.status = .error
            }
            CTAButton(title: "Quit") {
                gameStore.status = .idle
            }
        }
        .alert(isPresented: .constant(gameStore.status == .error)) {
            Alert(title: Text("Error"), dismissButton: .default(Text("OK")) {
                gameStore.status = .idle
            })
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
