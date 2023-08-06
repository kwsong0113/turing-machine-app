import InjectHotReload
import SwiftUI

struct ResultView: View {
    @ObservedObject private var inject = Inject.observer
    @EnvironmentObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    @State var showAnimation = false
    var title: String {
        switch gameViewModel.result {
        case .winner:
            return gameViewModel.isUserWinner ? "You Win!" : "You Lose!"
        default:
            return "Tie!"
        }
    }

    var digits: [Int] {
        let code = gameViewModel.problem?.code ?? 333
        return [code / 100 - 1, (code / 10) % 10 - 1, code % 10 - 1]
    }

    var isBothCorrect: Bool {
        gameViewModel.result == .bothCorrect
    }

    var body: some View {
        VStack(spacing: 20) {
            if showAnimation, title == "Tie!" {
                GroupBox {} label: {
                    Text(
                        isBothCorrect ? Image(systemName: "checkmark.circle.fill")
                            : Image(systemName: "xmark.circle.fill"))
                        .foregroundColor(isBothCorrect ? .blue : .red)
                        +
                        Text(isBothCorrect ? " Both correct!" : " Both incorrect!")
                }
                .transition(.move(edge: .bottom))
            }
            if showAnimation {
                GroupBox {
                    ThreeDigitPicker(digits: .constant(digits), disabled: true)
                } label: {
                    Text("The answer code is")
                        .foregroundColor(.blue)
                }
                .transition(.move(edge: .bottom))
            }
            Spacer()
        }
        .padding()
        .navigationTitle(title)
        .onAppear {
            withAnimation {
                showAnimation.toggle()
            }
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResultView()
        }
        .environmentObject(GameViewModel(
            status: .result,
            problem: Problem(id: "Example", verifiers: [1, 2, 3], laws: [1, 2, 3], code: 343),
            result: .bothCorrect,
            isUserWinner: false
        )
        )
    }
}
