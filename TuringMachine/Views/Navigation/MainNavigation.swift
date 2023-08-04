//

import SwiftUI

struct MainNavigation: View {
    var body: some View {
        NavigationView {
            HomeView()
        }
    }
}

struct MainStack_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigation()
    }
}
