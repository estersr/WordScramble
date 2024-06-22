//
//  ContentView.swift
//  WordScramble
//
//  Created by Esther Ramos on 18/06/24.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    ForEach(usedWords, id:\.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    func addNewWord() {
        // lowercase and trim the word, to make sure we don't add duplicate words with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        //exit if the remaining string is empty
        guard answer.count > 0 else {return}
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word was already used", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    func startGame() {
        // 1. Find the URL for start.txt in out app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splittling on line breaks
                let allWords = startWords.components(separatedBy: "\n")
                
                //4. Pick one random word, or use "silkworm"as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"
                
                // if we are here everything worked, so we can exit
                return
            }
        }
        
        //if we are here then there was a problem - trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
      //used words contains the word? be true if its in there or not. we are flipping around, if it cotains, the word is not original, so its false.
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        //1. a copy of our rootWord so we can modify it freely
        var tempWord = rootWord
         //2. then loop over every letter in the word we are spelling
        for letter in word {
            //3. we are saying 'can we find that in our temp word or not?' (pos is for the word position)
            //if we find this letter in out tempword put position into here.
            if let pos = tempWord.firstIndex(of: letter){
                //4. we found it? we'll do tempword, then we will remove at position, remove from out temporary copy of the rootword and it cant be used again.
                tempWord.remove(at: pos)
                
            } else {
                //5. if we cant find the letter, stop searching/looping over and send false immediately
                return false
            }
        }
        //6. we got to the end of the loop, got every letter in the word, it was there. return true, that word was possible.
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
        //We can then pass those directly on to SwiftUI by adding an alert() modifier below .onAppear()
    }
     
}

#Preview {
    ContentView()
}
