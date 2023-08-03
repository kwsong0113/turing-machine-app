import InjectHotReload
import SwiftUI

enum FocusedField {
    case field
}

struct RegisterView: View {
    @ObservedObject private var inject = Inject.observer
    @FocusState private var focusedField: FocusedField?
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = RegisterViewModel()

    private func onSubmit() {
        Task {
            await viewModel.register {
                dismiss()
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Username", text: $viewModel.username)
                    .focused($focusedField, equals: .field)
                    .onAppear {
                        focusedField = .field
                    }
                    .onSubmit {
                        onSubmit()
                    }
                Spacer()
            }
            .navigationTitle("Enter Username")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing:
            Button("Done") {
                onSubmit()
            })
            .padding()
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
