import InjectHotReload
import SwiftUI
import WrappingHStack

struct CriteriaView: View {
    @ObservedObject private var inject = Inject.observer
    @EnvironmentObject var viewModel: GameViewModel
    var recordForEachVerifier: [[Int]] {
        var computedRecord = Array(repeating: [Int](), count: 6)
        viewModel.verificationRecord.enumerated().forEach { stage, resultArray in
            let num = viewModel.proposalRecord[stage]
            resultArray.enumerated().forEach { verifierIndex, result in
                if result == .skip { return }
                computedRecord[verifierIndex].append(result == .correct ? num : -num)
            }
        }
        return computedRecord
    }

    var body: some View {
        List {
            if let problem = viewModel.problem {
                ForEach(Array(zip(problem.verifiers.indices, problem.verifiers)), id: \.0) { index, item in
                    VStack {
                        HStack {
                            Image(systemName: "\(index.toAlphabet().lowercased()).square.fill")
                                .foregroundColor(.blue)
                                .font(.title3)

                            Spacer(minLength: 20)
                            RemoteImage(url: """
                            https://turingmachine.info/images/criteriacards/\
                            EN/TM_GameCards_EN-\(String(format: "%02d", item)).png
                            """) {
                                ProgressView()
                            }
                        }
                    }
                    if recordForEachVerifier[index].count > 0 {
                        WrappingHStack(recordForEachVerifier[index].indices, id: \.self) { recordIndex in
                            NumberBadge(num: abs(recordForEachVerifier[index][recordIndex]),
                                        isCorrect: recordForEachVerifier[index][recordIndex] > 0)
                        }
                    }
                }
            } else {
                ProgressView()
            }
            Spacer()
                .listRowSeparator(.hidden, edges: .bottom)
                .listRowBackground(EmptyView())
        }
        .listStyle(.plain)
        .background(Color(.systemBackground))
        .enableInjection()
    }
}

struct CriteriaView_Previews: PreviewProvider {
    static var previews: some View {
        CriteriaView()
            .environmentObject(GameViewModel(
                status: .proposal,
                problem: Problem(id: "Example", verifiers: [1, 2, 3], laws: [1, 2, 3], code: 444)
            ))
    }
}
