//
//  AddNewWordView.swift
//  Wordler
//
//  Created by danilka on 17.06.2023.
//

import SwiftUI
import RealmSwift

struct AddNewWordView: View {
    
    enum Field: Hashable {
        case myField
    }
    
    @State private var category = ""
    @State private var word = ""
    @State private var translation = ""
    @State private var note = ""
    @State private var showAlert = false
    @EnvironmentObject var listViewModel: ListViewModel
    
    var wordTitle = "Word"
    var titleTitle = "Translation"
    
    @ObservedResults(WordItem.self) var wordItems
    @ObservedResults(CategoryItem.self) var categoryItems
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                
                Spacer()
                Text("New word")
                    .offset(x: 10)
                    .font(.system(size: 28, weight: .semibold))
                
                Spacer()
                
                Button {
                    listViewModel.isShowAddView.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 23, height: 23)
                        .foregroundColor(.black)
                }
                
                
            }
            
            HStack {
                Text("🇺🇸")
                    .font(.system(size: 31))
                
                Picker(selection: $category) {
                    
                    Text("Empty")
                    
                    ForEach(categoryItems, id: \.id) { category in
                        Text(category.title)
                            .tag(category.title)
                    }
                } label: {
                    Text("Select category")
                }
                .padding(.horizontal, 10)
                .background(Color.myGray)
                .clipShape(Capsule())
                
            }
            
            VStack(spacing: 15) {
                TextFieldView(text: $word, icon: "", title: wordTitle)
                TextFieldView(text: $translation, icon: "", title: titleTitle)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Note")
                    .font(.system(size: 20))
                    .foregroundColor(.black.opacity(0.5))
                TextEditor(text: $note)
                    .scrollContentBackground(.hidden)
                    .padding(15)
                    .background(Color.myGray)
                    .cornerRadius(15)
                    .frame(height: UIScreen.main.bounds.height / 3)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .myField)
                    .onTapGesture {
                        focusedField = nil
                    }
                
                
                Spacer()
                Button {
                    
                    if word.isEmpty, translation.isEmpty, category.isEmpty {
                        showAlert.toggle()
                    } else {
                        let newWord = WordItem()
                        newWord.mainWord = word
                        newWord.wordNote = note
                        newWord.wordTranslate = translation
                        newWord.category = category
                        
                        $wordItems.append(newWord)
                        
                        withAnimation {
                            listViewModel.isShowAddView.toggle()
                        }
                    }
                    
                    
                } label: {
                    GreenButton(text: "Save")
                }
                .alert(Text("Empty fields"), isPresented: $showAlert, actions: {})
                
                
                
            }
            .padding(.top, 5)
            .background(Color.white)
        }
        .padding(.top, 5)
        .padding(.horizontal, 15)
        .background(Color.white)
    }
}
    
    struct AddNewWordView_Previews: PreviewProvider {
        static var previews: some View {
            AddNewWordView()
        }
    }



