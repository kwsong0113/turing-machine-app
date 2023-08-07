import InjectHotReload
import SwiftUI

struct VerificationView: View {
    @ObservedObject private var inject = Inject.observer
    @EnvironmentObject var viewModel: GameViewModel

    var body: some View {
        List {
            HStack {
                HStack {
                    Image(systemName: "number.square")
                }
                .frame(width: 70, alignment: .leading)
                ForEach(0 ..< (viewModel.problem?.verifiers.count ?? 0), id: \.self) { index in
                    Spacer()
                    Image(systemName: "\(index.toAlphabet().lowercased()).square.fill")
                        .foregroundColor(.blue)
                }
            }
            ForEach(Array(zip(viewModel.verificationRecord.indices,
                              viewModel.verificationRecord)), id: \.0)
            { index, resultArray in
                HStack {
                    HStack {
                        Image(systemName: "\(index + 1).square")
                        Text("\(viewModel.proposalRecord[index])")
                            .foregroundColor(.blue)
                    }
                    .frame(width: 70, alignment: .leading)
                    ForEach(resultArray[0 ..< (viewModel.problem?.verifiers.count ?? 0)].indices,
                            id: \.self)
                    { verifierIndex in
                        Spacer()
                        switch resultArray[verifierIndex] {
                        case .correct:
                            Image(systemName: "checkmark.square.fill")
                                .foregroundColor(Color("Primary"))
                        case .wrong:
                            Image(systemName: "xmark.square.fill")
                                .foregroundColor(.red)
                        case .skip:
                            Image(systemName: "square")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            Spacer()
                .listRowSeparator(.hidden, edges: .bottom)
                .listRowBackground(EmptyView())
        }
        .listStyle(.plain)
        .enableInjection()
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView()
            .environmentObject(GameViewModel(
                status: .proposal,
                problem: Problem(id: "Example", verifiers: [1, 2, 3, 4, 5, 6], laws: [1, 2, 3, 4, 5, 6], code: 444),
                verificationRecord: [
                    [.correct, .correct, .wrong, .wrong, .correct, .skip],
                    [.correct, .correct, .skip, .wrong, .correct, .skip],
                    [.correct, .correct, .skip, .wrong, .correct, .skip],
                ],
                proposalRecord: [423, 124, 325]
            ))
    }
}
