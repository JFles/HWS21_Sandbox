//
//  Day2_Session1.swift
//  Day2_Session1
//
//  Created by Jeremy Fleshman on 8/3/21.
//

import SwiftUI

/// inefficient algorithm
/// Can be improved by allowing the task to suspend
func factors(for number: Int) async -> [Int] {
    var result = [Int]()

    /// algo goes past the half of the target number
    /// duplicates the factor check -- easy way to make this more efficient
    for check in 1...number {
        if number.isMultiple(of: check) {
            result.append(check)
            /// Paul recommends suspending after finding a multiple
            /// It will suspend a lot in early factors, but it will allow the
            /// algo to have less churn at the higher factors
            await Task.suspend()
        }

        /// If task is cancelled, can return the result so far
        if Task.isCancelled {
            return result
        }

    }

    return result
}

/// Demo func for `TaskGroup`
func printMessage() async {
    let string = await withTaskGroup(of: String.self) { group -> String in
        group.addTask { "Hello" }
        group.addTask { "from" }
        group.addTask { "a" }
        group.addTask { "Task" }
        group.addTask { "Group" }

        var collected = [String]()

        for await value in group {
            collected.append(value)
        }

        return collected.joined(separator: " ")
    }

    print(string)

}

enum Day2_Session1 {

    struct Message: Codable, Identifiable {
        let id: Int
        let user: String
        let text: String
    }

    struct Day2_Session1: View {
        @State private var inbox = [Message]()
        @State private var sent = [Message]()

        @State private var selectedBox = "Inbox"
        let messageBoxes = ["Inbox", "Sent"]

        var messages: [Message] {
            if selectedBox == "Inbox" {
                return inbox
            } else {
                return sent
            }
        }

        var body: some View {
            NavigationView {
                List(messages) { message in
                    Text("\(message.user): ").bold() +
                    Text(message.text)
                }
                .navigationTitle("Inbox")
                .toolbar {
                    Picker("Select a message box", selection: $selectedBox) {
                        ForEach(messageBoxes, id: \.self, content: Text.init)
                    }
                    .pickerStyle(.segmented)
                }
                .task {
                    /// equivalent of `async let` -- how to add async priority
                    do {
//                        let inboxTask = Task { () -> [Message] in
//                            /// This doesn't need to explicitly check for cancellation
//                            /// Apple's API's have an implicit cancellation in URLSession
//                            return try await fetchInbox()
//                        }

                        /// async paging for getting inbox in chunks
                        inbox = try await withThrowingTaskGroup(of: [Message].self) { group -> [Message] in
                            for i in 1...3 {
                                group.addTask {
                                    let url = URL(string: "https://hws.dev/inbox-\(i).json")!
                                    let (data, _) = try await URLSession.shared.data(from: url)
                                    return try JSONDecoder().decode([Message].self, from: data)
                                }
                            }

                            /// stick the arrays back together
                            let allMessages = try await group.reduce(into: [Message]()) { $0 += $1}
                            /// HAVE to make sure that the messages are back in order
                            return allMessages.sorted { $0.id < $1.id}
                        }

                        let sentTask = Task { () -> [Message] in
                            /// Example of sleeping before starting an `async task`
//                            try await Task.sleep(seconds: 1)
                            return try await fetchSent()
                        }

                        /// Calling cancel for the `async` task works without explicit `cancellation`
                        /// handling in `inboxTask`
//                        inboxTask.cancel()

//                        inbox = try await inboxTask.value
                        sent = try await sentTask.value

                        /// Example `TaskGroup` for demo func `printMessage()`
//                        await printMessage()

                    } catch {
                        print(error.localizedDescription)
                    }



                        /// using `Task` per async call allows them to complete when they're done
                        /// and update with their results
                        /// No longer have to wait like in `async let` and no longer have to catch errors in `do-catch`
                        //                    Task { inbox = try await fetchInbox() }
                        //                    Task { sent = try await fetchSent() }
                }
            }
        }

        func fetchInbox() async throws -> [Message] {
            let inboxURL = URL(string: "https://hws.dev/inbox.json")!
            return try await URLSession.shared.decode(from: inboxURL)
        }

        func fetchSent() async throws -> [Message] {
            let inboxURL = URL(string: "https://hws.dev/sent.json")!
            return try await URLSession.shared.decode(from: inboxURL)
        }


    }


    struct Day2_Session1_Previews: PreviewProvider {
        static var previews: some View {
            Day2_Session1()
        }
    }

}

