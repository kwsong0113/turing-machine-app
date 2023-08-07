import SwiftUI

struct NumberBadge: View {
    let num: Int
    let isCorrect: Bool

    var body: some View {
        Text("\(num)")
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(4)
            .background(RoundedRectangle(cornerRadius: 8).fill(isCorrect ? Color("Primary") : .red))
            .padding(.vertical, 3)
    }
}

struct NumberBadge_Previews: PreviewProvider {
    static var previews: some View {
        NumberBadge(num: 342, isCorrect: true)
        NumberBadge(num: 342, isCorrect: false)
    }
}
