//
//  ContentView.swift
//  Sample Project
//
//  Created by Felipe Espinoza on 27/01/2024.
//

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
