//
//  Day3_Session2.swift
//  Day3_Session2
//
//  Created by Jeremy Fleshman on 8/4/21.
//

import SwiftUI

enum Day3_Session2 {

    /// Searchable example
    struct ContentView: View {
        @State private var search = ""
        let myData = ["actor", "class", "enum", "struct"]

        /// live filtering based on the bound `search` property
        var filteredData: [String] {
            if search.isEmpty {
                return myData
            } else {
                return myData.filter { $0.localizedCaseInsensitiveContains(search)}
            }
        }

        var body: some View {
            NavigationView {
                List(filteredData, id:\.self) { item in
                    Text(item)
                        .listRowSeparatorTint(.mint)
                }
                .searchable(text: $search, prompt: "Filter results") {
                    ForEach(filteredData, id: \.self) { item in
                        Text("Search \"\(item)\"?").searchCompletion(item)
                    }
                }
                .navigationTitle("Dataaaaaa")
            }
        }
    }

    /// Refreshable Example
//    struct ContentView: View {
//        @State private var numbers = [String]()
//
//        var body: some View {
//            List(0..<numbers.count, id: \.self) { i in
//                Text(numbers[i])
//            }
//            .task(rollDice)
//            .refreshable(action: rollDice)
//        }
//
//        func rollDice() {
//            let result = Int.random(in: 1...6)
//            numbers.append(String(result))
//        }
//    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

}
