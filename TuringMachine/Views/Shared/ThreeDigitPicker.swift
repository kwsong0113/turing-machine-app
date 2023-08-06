//

import SwiftUI

struct ThreeDigitPicker: View {
    let digits: Binding<[Int]>
    var disabled: Bool = false

    var body: some View {
        HStack {
            ForEach(0 ..< 3) {
                Picker("Digit \($0)", selection: digits[$0]) {
                    ForEach(1 ..< 6) {
                        Text(String($0))
                    }
                }
                .pickerStyle(.wheel)
                .disabled(disabled)
            }
        }
    }
}

struct ThreeDigitPicker_Previews: PreviewProvider {
    static var previews: some View {
        ThreeDigitPicker(digits: .constant([3, 3, 2]), disabled: false)
    }
}
