//
//  Day1_Session4.swift
//  Day1_Session4
//
//  Created by Jeremy Fleshman on 8/2/21.
//

import SwiftUI

enum Day1_Session4 {

    struct Message: Codable, Identifiable {
        let id: Int
        let user: String
        let text: String
    }

    struct Day1_Session4: View {
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
                    /// equivalent of `async let`
//                    do {
//                        let inboxTask = Task { () -> [Message] in
//                            try await fetchInbox()
//                        }
//                        let sentTask = Task { () -> [Message] in
//                            try await fetchSent()
//
//                        }
//
//                        inbox = try await inboxTask.value
//                        sent = try await sentTask.value
//
//                    } catch {
//                        print(error.localizedDescription)
//                    }

                    /// equivalent of `async let`  -- with the `Result` type from the `Task`
//                    do {
//                        let inboxTask = Task { () -> [Message] in
//                            try await fetchInbox()
//                        }
//                        let sentTask = Task { () -> [Message] in
//                            try await fetchSent()
//
//                        }
//
//                        let inboxResult = await inboxTask.result
//                        let sentResult = await sentTask.result
//
//                        /// `async` has been finished at this point, so this is all `sync` code that can be passed around
//                        inbox = try inboxResult.get()
//                        sent = try sentResult.get()
//
//                    } catch {
//                        print(error.localizedDescription)
//                    }


                    /// equivalent of `async let` -- how to add async priority
                    do {
                        let inboxTask = Task { () -> [Message] in
                            print(">>> \(Task.currentPriority)")
                            return try await fetchInbox()
                        }
                        let sentTask = Task { () -> [Message] in
                            try await fetchSent()

                        }

                        inbox = try await inboxTask.value
                        sent = try await sentTask.value

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


    struct Day1_Session4_Previews: PreviewProvider {
        static var previews: some View {
            Day1_Session4()
        }
    }
    
}
