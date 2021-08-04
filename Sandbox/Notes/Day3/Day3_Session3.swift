//
//  Day3_Session3.swift
//  Day3_Session3
//
//  Created by Jeremy Fleshman on 8/4/21.
//

import SwiftUI

enum Day3_Session3 {

    /// `FocusState` example for multiple fields that can be focused
    struct ContentView: View {
        enum Field { case firstName, lastName }

        @State private var firstName = ""
        @State private var lastName = ""
        @FocusState private var focusedField: Field?

        var body: some View {
            VStack {
                TextField("First name", text: $firstName)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .firstName)
                    .textContentType(.givenName)
                    .submitLabel(.next)

                TextField("Last name", text: $lastName)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .lastName)
                    .textContentType(.familyName)
                    .submitLabel(.done)
            }
            .onSubmit {
                switch focusedField {
                    case .firstName:
                        focusedField = .lastName
                    default:
                        focusedField = nil
                }
            }

        }
    }

    /// `FocusState` simple example for handling the keyboard
//    struct ContentView: View {
//        @State private var phoneNumber = ""
//        @FocusState private var numberIsFocused: Bool
//
//        var body: some View {
//            VStack {
//                TextField("Enter your phone number", text: $phoneNumber)
//                    .textFieldStyle(.roundedBorder)
//                    .keyboardType(.numberPad)
//                    .focused($numberIsFocused)
//
//                Button("Submit") {
//                    numberIsFocused = false
//                }
//            }
//        }
//    }


    /// Example of `symbolRenderingMode`
//    struct ContentView: View {
//        var body: some View {
//
//            VStack {
//                Spacer()
//
//                Text("Hierarchical")
//                Image(systemName: "person.3.sequence.fill")
//                    .symbolRenderingMode(.hierarchical)
//                    .font(.system(size: 120))
//                    .foregroundColor(.green)
//                    .padding()
//
//                Spacer()
//
//                Text("Palette")
//                Image(systemName: "person.3.sequence.fill")
//                    .symbolRenderingMode(.palette)
//                    .font(.system(size: 120))
//                    /// `foregroundStyle` is very powerful
//                    /// Even has the ability to have gradient colors
//                    .foregroundStyle(.cyan, .mint, .indigo)
//                    .padding()
//
//                Spacer()
//            }
//        }
//    }

    /// Searchable example
    /// Swipe actions example
//    struct ContentView: View {
//        @State private var search = ""
//        let myData = ["actor", "class", "enum", "struct"]
//
//        /// live filtering based on the bound `search` property
//        var filteredData: [String] {
//            if search.isEmpty {
//                return myData
//            } else {
//                return myData.filter { $0.localizedCaseInsensitiveContains(search)}
//            }
//        }
//
//        var body: some View {
//            NavigationView {
//                List(filteredData, id:\.self) { item in
//                    Text(item)
//                        .listRowSeparatorTint(.mint)
//                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
//                            Button {
//                                print("\(item) is a favorite!")
//                            } label: {
//                                Label("Favorite", systemImage: "star")
//                            }
//                            .tint(.mint)
//                        }
//                }
//                .searchable(text: $search, prompt: "Filter results")
//                .navigationTitle("Dataaaaaa")
//            }
//        }
//    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

}
