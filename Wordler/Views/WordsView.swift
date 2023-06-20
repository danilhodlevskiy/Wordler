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
    @ObservedResults(CategoryItem.self) var categoryItems
    
    @State private var shuffledWordItems = [WordItem]()
    @State private var index = 0
    @State private var category = ""
    @State private var showTranslation = false
    @State private var word: WordItem = WordItem()
    @State private var isAllWords = false
    @State private var isStart = true
    @State private var isEmptyArray = false
    
    @State private var offsetX: CGFloat = 0
    @State private var opacity: CGFloat = 1
    
    var body: some View {
        VStack(spacing: -5) {
            
            if isStart || isAllWords {
                Picker(selection: $category, content: {
                    
                    Text("All")
                        .tag("")
                    
                    ForEach(categoryItems, id:\.id) { category in
                        Text(category.title)
                            .tag(category.title)
                    }
                }, label: {
                    Text("select category")
                })
                .foregroundColor(.accentColor)
            } else {
                Text("")
            }
            

            
            Spacer()
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: -5) {
                    Text(isAllWords || isStart ? "" : "EN")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.init(hex: 0xb6b6b6))
                    VStack(alignment: .center) {
                        Text("\(isStart ? "Let's go🏁" : isAllWords ? "That is all🎉" : word.mainWord)")
                            .font(.system(size: 48, weight: .bold))
                    }

                }
                
                ZStack {
                    Text("\(word.wordTranslate)")
                        .font(.system(size: 32, weight: .light))
                        .opacity(showTranslation ? isAllWords ? 0 : 100 : 0)
                    
                    Button {
                        showTranslation = true
                    } label: {
                        TranslateButton(text: "Translate")
                            .opacity(showTranslation ? 0 : isAllWords || isStart ? 0 : 100)
                    }
                        
                }
            }
            .opacity(opacity)
            .offset(x: offsetX)

            
            
            Spacer()
            
            Button {
                
                if isStart {
                    if wordItems.filter({ word in
                        word.category == category
                    }).count != 0 {
                        
                        withAnimation {
                            offsetX = -50
                            opacity = 0

                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            isStart = false
                            if category != "" {
                                shuffledWordItems = wordItems.filter({ word in
                                    word.category == category
                                }).shuffled()
                                word = shuffledWordItems[index]
                            } else {
                                shuffledWordItems = wordItems.shuffled()
                                word = shuffledWordItems[index]
                            }
                            
                            offsetX = 50
                            
                            withAnimation {
                                offsetX = 0
                                opacity = 1
                            }
                        }
                        

                    } else {
                        isEmptyArray = true
                    }
                    
                    

                } else {
                    if !isAllWords {
                        withAnimation {
                            offsetX = -50
                            opacity = 0

                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            next()
                            showTranslation = false
                            offsetX = 50
                            
                            withAnimation {
                                offsetX = 0
                                opacity = 1
                            }
                        }
                        
                    } else {
                        
                        if wordItems.filter({ word in
                            word.category == category
                        }).count != 0 {
                            if category != "" {
                                index = 0
                                isAllWords = false
                                shuffledWordItems = wordItems.filter({ word in
                                    word.category == category
                                }).shuffled()
                                word = shuffledWordItems[index]
                            } else {
                                withAnimation {
                                    index = 0
                                    isAllWords = false
                                    shuffledWordItems = wordItems.shuffled()
                                    word = shuffledWordItems[index]
                                }
                                
                            }
                        } else {
                            isEmptyArray = true
                        }
                    }
                }
                


            } label: {
                HStack(spacing: 0) {
                    
                    Text( isStart ? "Start" : isAllWords ? "Restart" : "Next")
                        .font(.system(size: 20))
                    Image(systemName: isAllWords ? "arrow.counterclockwise" : "chevron.right")
                }
            }
            .alert(Text("Category is empty"), isPresented: $isEmptyArray, actions: {})
            
            Rectangle()
                .opacity(0)
                .frame(height: 15)
        }
        .onAppear {
            isEmptyArray = false
            isStart = true
        }
        
        
        
    }
    
    func next() {
        if index < shuffledWordItems.count-1 {
            index+=1
            word = shuffledWordItems[index]
        } else {
            isAllWords = true
        }
        
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

