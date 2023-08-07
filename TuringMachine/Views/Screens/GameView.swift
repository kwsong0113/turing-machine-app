import BottomSheetSwiftUI
import InjectHotReload
import SwiftUI

struct GameView: View {
    @ObservedObject private var inject = Inject.observer
    @ObservedObject var viewModel = GameViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Group {
                switch viewModel.status {
                case .waitingForOtherUsers:
                    LoadingView(message: "Waiting for other users")
                case .waitingForProblemSelection:
                    LoadingView(message: "Your opponent is choosing a problem")
                case .problemSelecting:
                    ProblemSelectionView()
                case .proposal, .proposalResult:
                    QuestionView()
                case .thumb:
                    ThumbView()
                case .result:
                    ResultView()
                }
            }
            .navigationBarItems(leading:
                HStack {
                    if viewModel.status != .result {
                        Button {
                            quitAndDismiss()
                        } label: {
                            Text("Quit")
                        }
                    }
                    switch viewModel.status {
                    case .proposal, .proposalResult, .thumb, .result:
                        Text("Round #\(viewModel.stage)")
                            .foregroundColor(Color("Primary"))
                    default:
                        EmptyView()
                    }
                }, trailing:
                Group {
                    if viewModel.status == .result {
                        Button {
                            quitAndDismiss()
                        } label: {
                            Text("Leave")
                        }
                    }
                })
        }
        .bottomSheet(
            bottomSheetPosition: $viewModel.bottomSheetPosition,
            switchablePositions: [.dynamicTop, .dynamicBottom, .hidden],
            headerContent: {
                VStack(alignment: .leading) {
                    Text("Problem")
                        .font(.title2).bold()

                    Picker("Tab", selection: $viewModel.selectedTab) {
                        ForEach(Tab.allCases) {
                            Text("\($0 == .criteria ? "Criteria Cards" : "Verification Results")")
                        }
                    }
                    .pickerStyle(.segmented)
                    Divider().padding(EdgeInsets(top: 10, leading: -20, bottom: 0, trailing: -20))
                }
                .padding([.horizontal])
            },
            mainContent: {
                switch viewModel.selectedTab {
                case .criteria:
                    CriteriaView()
                case .verification:
                    VerificationView()
                }
            }
        )
        .alert("Error", isPresented: $viewModel.isError, actions: {
            Button("OK") {
                quitAndDismiss()
            }
        }, message: { Text(viewModel.errorMessage ?? "") })
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
        GameView(viewModel: GameViewModel(
            status: .proposal,
            problem: Problem(id: "Example", verifiers: [1, 2, 3, 4], laws: [1, 2, 3], code: 444),
            bottomSheetPosition: .dynamicTop
        ))
    }
}
