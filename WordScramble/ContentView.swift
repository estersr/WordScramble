//
//  ContentView.swift
//  WordScramble
//
//  Created by Esther Ramos on 18/06/24.
//

import SwiftUI

struct ContentView: View {
    let people = ["Finn", "Leia", "Luke", "Rey"]
    var body: some View {
        List {
            Text("Static Row")

            ForEach(people, id: \.self) {
                Text($0)
            }

            Text("Static Row")
        }
    }
}

#Preview {
    ContentView()
}
