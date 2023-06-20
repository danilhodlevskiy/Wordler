//
//  WordsView.swift
//  Wordler
//
//  Created by danilka on 17.06.2023.
//

import SwiftUI
import RealmSwift

struct WordsView: View {
    @ObservedResults(WordItem.self) var wordItems
    
    
    @State private var category = ""
    @State private var showTranslation = false
    @State private var word: WordItem = WordItem()
    
    var body: some View {
        VStack(spacing: -5) {
            
            Picker(selection: $category, content: {
                ForEach(0..<5) { element in
                    Text("Transport")
                }
            }, label: {
                Text("select category")
            })
            .foregroundColor(.accentColor)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: -5) {
                Text("EN")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.init(hex: 0xb6b6b6))
                Text("\(word.mainWord)")
                    .font(.system(size: 48, weight: .bold))
            }
            
            Rectangle()
                .opacity(0)
                .frame(height: 15)
            
            ZStack {
                Text("\(word.wordTranslate)")
                    .font(.system(size: 32, weight: .light))
                    .opacity(showTranslation ? 100 : 0)
                
                TranslateButton(text: "Translate")
                    .opacity(showTranslation ? 0 : 100)
                    .onTapGesture {
                        withAnimation {
                            showTranslation = true
                        }
                    }
                    
            }
            
            
            Spacer()
            
            Button {
                withAnimation {
                    getRandom()
                    showTranslation = false
                }
            } label: {
                HStack(spacing: 0) {
                    
                    Text("Next")
                        .font(.system(size: 20))
                    Image(systemName: "chevron.right")
                }
            }
            
            Rectangle()
                .opacity(0)
                .frame(height: 15)
        }.onAppear {
            getRandom()
        }
        
        
        
    }
    
    func getRandom() {
        let random = Int.random(in: 0..<wordItems.count)
        
        word = wordItems[random]
    }
    
}

struct WordsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TranslateButton: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 60)
            .padding(.vertical, 10)
            .background(Color.accentColor)
            .clipShape(Capsule())
    }
}

