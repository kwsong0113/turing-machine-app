import InjectHotReload
import SwiftUI

struct ProblemSelectionView: View {
    @ObservedObject private var inject = Inject.observer
    @EnvironmentObject var gameViewModel: GameViewModel
    @StateObject var problemSelectionViewModel = ProblemSelectionViewModel()

    var body: some View {
        VStack(spacing: 20) {
            GroupBox {
                Text("Difficulty")
                    .font(.headline)
                Picker("Difficulty", selection: $problemSelectionViewModel.difficulty) {
                    ForEach(Difficulty.allCases) { Text($0.rawValue.capitalized) }
                }
                .pickerStyle(.segmented)
            }
            GroupBox {
                Text("Verifiers")
                    .font(.headline)
                Picker("Verifiers", selection: $problemSelectionViewModel.numVerifiers) {
                    Text("4").tag(4)
                    Text("5").tag(5)
                    Text("6").tag(6)
                }
                .pickerStyle(.segmented)
            }
            Spacer()
            CTAButton(title: "Generate") {
                gameViewModel.sendProblemMessage(
                    difficulty: problemSelectionViewModel.difficulty.value,
                    numVerifiers: problemSelectionViewModel.numVerifiers
                )
            }
        }
        .padding()
        .navigationTitle("Choose a Problem")
        .enableInjection()
    }
}

struct ProblemSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemSelectionView()
    }
}
