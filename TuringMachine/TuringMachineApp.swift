import SwiftUI

@main
struct TuringMachineApp: App {
    @StateObject var gameStore = GameStore()

    var body: some Scene {
        WindowGroup {
            MainNavigation()
                .environmentObject(gameStore)
        }
    }
}
