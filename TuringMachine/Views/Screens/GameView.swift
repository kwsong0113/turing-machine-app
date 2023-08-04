import InjectHotReload
import SwiftUI

struct GameView: View {
    @ObservedObject private var inject = Inject.observer
    @ObservedObject private var viewModel = GameViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            switch viewModel.status {
            case .waitingForOtherUsers:
                LoadingView(message: "Waiting for other users")
            case .waitingForProblemSelection:
                LoadingView(message: "Your opponent is choosing a problem")
            case .problemSelecting:
                ProblemSelectionView()
            case .proposal:
                LoadingView(message: "Proposal")
            case .thumb:
                LoadingView(message: "Thumb")
            case .result:
                LoadingView(message: "Result")
            }
        }
        .alert(isPresented: $viewModel.isError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? ""),
                dismissButton: .default(Text("OK")
                ) {
                    viewModel.isError = false
                    quitAndDismiss()
                }
            )
        }
        .environmentObject(viewModel)
        .enableInjection()
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
