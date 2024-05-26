import SwiftUI

struct ContentView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor.white
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        itemAppearance.selected.iconColor = UIColor.green
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.green]
        
        appearance.stackedLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView {
            ChordPlayer()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("Play Chord")
                }
            
            Metronome()
                .tabItem {
                    Image(systemName: "metronome")
                    Text("Metronome")
                }
            
            ChordLibrary()
                .tabItem {
                    Image(systemName: "music.quarternote.3")
                    Text("Chord Library")
                }
        }
        .tint(.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
