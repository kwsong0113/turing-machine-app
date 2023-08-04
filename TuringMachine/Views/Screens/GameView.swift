import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("\(viewModel.stage)")
            CTAButton(title: "Error") {
                viewModel.showError(message: "Error")
            }
            CTAButton(title: "Quit") {
                quitAndDismiss()
            }
        }
        .alert(isPresented: $viewModel.isError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? ""),
                dismissButton: .default(Text("OK")
                ) {
                    quitAndDismiss()
                }
            )
        }
    }

    private func quitAndDismiss() {
        viewModel.quit {
            dismiss()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
