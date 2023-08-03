import InjectHotReload
import SwiftUI

struct CTAButton: View {
    @ObservedObject private var inject = Inject.observer
    let title: String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(Color("Primary"))
        .enableInjection()
    }
}

struct CTAButton_Previews: PreviewProvider {
    static var previews: some View {
        CTAButton(title: "Button") {
            print("Pressed")
        }
    }
}
