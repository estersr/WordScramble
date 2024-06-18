//
//  ContentView.swift
//  WordScramble
//
//  Created by Esther Ramos on 18/06/24.
//

import SwiftUI

struct ContentView: View {
    func testStrings() {
        let word = "swift"
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        let allGood = misspelledRange.location == NSNotFound
    }
    
    var body: some View {
        VStack {
            
        }
    }
}

#Preview {
    ContentView()
}
