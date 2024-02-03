import SwiftUI

struct ContentView: View {
    @State private var offset = CGFloat.zero
    @State var imageSize: CGFloat = 400
    @State var fontSize: CGFloat = 50
    var body: some View {
        
        VStack {
            
            Image("Broccoli Tattoo")
                .resizable()
                .frame(width: imageSize, height: imageSize)
            
            ScrollView(.horizontal) {
                Text("Riz au curry et aux crevettes roses de Normandie")
                    .font(.system(size: fontSize))
            }
                        
            ScrollView {
                VStack {
                    ForEach(0..<50) { i in
                        Text("Item \(i)").padding()
                    }
                }.background(GeometryReader {
                    Color.clear.preference(key: ViewOffsetKey.self,
                        value: -$0.frame(in: .named("scroll")).origin.y)
                })
                .onPreferenceChange(ViewOffsetKey.self) { print("offset >> \($0)")
                    
                    if ((fontSize-$0) >= 10 && (fontSize-$0) <= 50) {
                        fontSize = fontSize-$0
                    }
                    
                    if ((imageSize-$0) >= 100 && (imageSize-$0) <= 400) {
                        imageSize = imageSize-$0
                        print("[\(imageSize)]")
                    }
                }
            }.coordinateSpace(name: "scroll")
            
        }
        
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
