import InjectHotReload
import SwiftUI

struct QuestionView: View {
    @ObservedObject private var inject = Inject.observer
    @EnvironmentObject var gameViewModel: GameViewModel
    @StateObject var questionViewModel = QuestionViewModel()
    @State var showProposalAnimation = false
    @State var showVerifierAnimation = false

    var body: some View {
        VStack(spacing: 20) {
            if showProposalAnimation {
                GroupBox {
                    HStack {
                        ForEach(0 ..< 3) {
                            Picker("Digit \($0)", selection: $questionViewModel.digits[$0]) {
                                ForEach(1 ..< 6) {
                                    Text(String($0))
                                }
                            }
                            .pickerStyle(.wheel)
                            .disabled(gameViewModel.status != .proposal)
                        }
                    }
                } label: {
                    Text("Compose your 3-digit proposals")
                }
                .transition(.move(edge: .bottom))
            }

            if let problem = gameViewModel.problem {
                ZStack {
                    if showVerifierAnimation {
                        GroupBox {
                            HStack {
                                Spacer()
                                ForEach(problem.verifiers.indices, id: \.self) { index in
                                    VStack(alignment: .leading, spacing: 20) {
                                        Toggle(isOn: $questionViewModel.isVerifiersOn[index]) {
                                            Text(intToAlphabet(index))
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        }
                                        .frame(width: 40, height: 40)
                                        .toggleStyle(.button)
                                        .buttonStyle(
                                            .borderedProminent
                                        )
                                        .tint(Color("Primary"))
                                        .disabled(gameViewModel.status != .proposal)
                                        if let verificationResult = gameViewModel.verificationResult {
                                            switch verificationResult[index] {
                                            case .correct:
                                                Image(systemName: "checkmark.square.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 40)
                                                    .foregroundColor(Color("Primary"))
                                            case .wrong:
                                                Image(systemName: "xmark.square.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 40)
                                                    .foregroundColor(.red)
                                            case .skip:
                                                Spacer()
                                            }
                                        } else {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 100)

                                    Spacer()
                                }
                            }

                            .padding(.top)
                        } label: {
                            Text("Select 3 verifiers")
                        }
                        .transition(.move(edge: .bottom))
                    }
                }
                .onAppear {
                    withAnimation {
                        showVerifierAnimation.toggle()
                    }
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Question")
        .navigationBarItems(trailing: Button(gameViewModel.status == .proposal ? "Submit" : "Done") {
            if gameViewModel.status == .proposal {
                gameViewModel.askQuestion(
                    proposal: questionViewModel.proposal,
                    verifierIndices: questionViewModel.verifierIndices
                )
            } else {
                gameViewModel.moveToThumb()
            }
        }
        .disabled(questionViewModel.isVerifiersOn.filter { $0 }.count != 3)
        )
        .onAppear {
            withAnimation {
                showProposalAnimation.toggle()
            }
        }
        .enableInjection()
    }

    func intToAlphabet(_ int: Int) -> String {
        guard let unicodeScalar = UnicodeScalar(97 + int) else { return "A" }
        return String(unicodeScalar).uppercased()
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
    }
}
