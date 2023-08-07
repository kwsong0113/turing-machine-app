import InjectHotReload
import SwiftUI

struct CTAButton: View {
    @ObservedObject private var inject = Inject.observer
    let title: String
    var isLoading: Bool = false
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .controlSize(.regular)
            } else {
                Text("**\(title)**")
                    .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(Color("Primary"))
        .disabled(isLoading)
        .enableInjection()
    }
}

struct CTAButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CTAButton(title: "Button") {
                print("Pressed")
            }
            .padding()
            .previewLayout(.sizeThatFits)

            CTAButton(title: "Button", isLoading: true) {
                print("Pressed")
            }
            .padding()
            .previewLayout(.sizeThatFits)
        }
    }
}
