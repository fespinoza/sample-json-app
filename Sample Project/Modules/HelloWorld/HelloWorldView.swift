import SwiftUI

struct HelloWorldView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!", comment: "The start of everything")
        }
        .padding()
    }
}

#Preview {
    HelloWorldView()
        .environment(\.locale, .init(identifier: "nb"))
}
