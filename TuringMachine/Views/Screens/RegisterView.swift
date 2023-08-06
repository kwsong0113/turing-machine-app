import InjectHotReload
import SwiftUI

enum FocusedField {
    case field
}

struct RegisterView: View {
    @ObservedObject private var inject = Inject.observer
    @FocusState private var focusedField: FocusedField?
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = RegisterViewModel()

    private func onSubmit() {
        viewModel.register {
            dismiss()
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Username", text: $viewModel.username)
                    .textInputAutocapitalization(.never)
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
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Button("Done") {
                        onSubmit()
                    }
                    .disabled(viewModel.username.count == 0)
                }
            })
            .padding()
        }
        .alert(isPresented: $viewModel.isError) {
            Alert(title: Text("Please Try Again"))
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
