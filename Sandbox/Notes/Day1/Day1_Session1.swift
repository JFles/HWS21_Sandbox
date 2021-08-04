//
//  Day1_What'sNewInSwift.swift
//  Day1_What'sNewInSwift
//
//  Created by Jeremy Fleshman on 8/2/21.
//

import SwiftUI

/// What's New In Swift Overview
enum Day1_Session1 {

    func test1() {
            // CGFloat and Double can now be used together
        let first: CGFloat = 42
        let second: Double = 19
        let result = first + second
        print(result)
    }
    func test2() {
            // Before Swift 5.5
            //    let names = ["Keeley", "Roy", "Ted"]
            //    let selected = names.randomElement() // Postfix member expression
            //    print(selected ?? "Anonymous")
            // New in Swift 5.5
        let names = ["Keeley", "Roy", "Ted"]
        let selected = names
#if DEBUG
            .first
#else
            .randomElement()
#endif
        print(selected ?? "Anonymous")
    }
    @propertyWrapper struct Clamped<T: Comparable> {
        let wrappedValue: T
        init(wrappedValue: T, range: ClosedRange<T>) {
            self.wrappedValue = min(max(wrappedValue, range.lowerBound), range.upperBound)
        }
    }
    func setScore1(to score: Int) {
        print("Setting score to \(score)")
    }
    func setScore2(@Clamped(range: 0...100) to score: Int) {
        print("Setting score to \(score)")
    }
    func test3() {
        setScore2(to: 50)
        setScore2(to: -50)
        setScore2(to: 500)
    }
    enum Vehicle: Codable {
        case bicycle(electric: Bool)
        case motorbike
        case car(seats: Int)
        case truck(wheels: Int)
    }
    func test4() {
        let traffic: [Vehicle] = [
            .bicycle(electric: false),
            .bicycle(electric: false),
            .car(seats: 4),
            .bicycle(electric: true),
            .motorbike,
            .truck(wheels: 8)
        ]
        do {
            let jsonData = try JSONEncoder().encode(traffic)
            let jsonString = String(decoding: jsonData, as: UTF8.self)
            print(jsonString)
            let newValues = try JSONDecoder().decode([Vehicle].self, from: jsonData)
            print(newValues.count)
        } catch {
            print("Kaboom!")
        }
    }
    func fibonacci(of number: Int) -> Int {
        var first = 0
        var second = 1
        for _ in 0..<number {
            let previous = first
            first = second
            second = previous + first
        }
        return first
    }
    func printFibonacci(of number: Int, allowAbsolute: Bool = false) {
            // Lazy var, will only be calculated if line 106 or 111 is hit. Not for line 108.
        lazy var result = fibonacci(of: abs(number))
        if number < 0 {
            if allowAbsolute {
                print("The result for \(abs(number)) is \(result)")
            } else {
                print("That's not a valid number in the sequence.")
            }
        } else {
            print("The result for \(number) is \(result).")
        }
    }
    func test5() {
        printFibonacci(of: 7)
    }
    struct User: Identifiable {
        let id = UUID()
        var name: String
        var isContacted = false
    }
    struct ContentView: View {
        @State private var users = [
            User(name: "Taylor"),
            User(name: "Justin"),
            User(name: "Adele")
        ]
        var body: some View {
                // No longer use ...Style() but start with . (static lookup)
                //        Toggle("Example", isOn: .constant(true))
                //            .toggleStyle(.switch)
                //        Text("Welcome")
                //        #if os(macOS)
                //            .font(.largeTitle)
                //        #else
                //            .font(.title)
                //        #endif
                // Bind to users directly instead of having to do users[user] etc
            List($users) { $user in
                HStack {
                    Text(user.name)
                    Spacer()
                    Toggle("Has been contacted", isOn: $user.isContacted)
                        .labelsHidden()
                }
            }
        }
    }
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
