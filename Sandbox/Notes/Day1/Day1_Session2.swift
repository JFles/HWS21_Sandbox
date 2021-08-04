//
//  Day1_Session2.swift
//  Day1_Session2
//
//  Created by Jeremy Fleshman on 8/2/21.
//

import SwiftUI

/// Intro to Concurrency
enum Day1_Session2 {

    struct Message: Codable, Identifiable {
        let id: Int
        let user: String
        let text: String
    }

    struct Day1_Session2: View {
        /// `@State` automatically pushes to main thread
        /// So that we don't have to do it manually
        @State private var inbox = [Message]()
        /// Adding this as part of a challenge
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
                    do {
                        /// `async` approach -- this is how the wrapper is called
                        /// same syntax without the wrapper
                        // before here is pre suspension
//                        inbox = try await fetchInbox()
                        // anything here could be executed at a much later time
                        // cannot assume same thread or state of the app here or view

                        /// pre-async approach
//                        fetchInbox { result in
//                            if case .success(let messages) = result {
//                                inbox = messages
//                            }
//                        }

                        /// Running two `await` back to back WILL NOT run these in parallel
                        /// These will be run synchronously
//                        inbox = try await fetchInbox()
//                        sent = try await fetchSent()

                        /// `async let` will spin off the async code so there is no suspension yet
                        /// But the return value will need to be awaited
                        async let inboxItems = fetchInbox()
                        async let sentItems = fetchSent()

                        inbox = try await inboxItems
                        /// `sent` still must await `inbox` returning first
                        /// however, both calls have been made in parallel -- partial optimization
                        sent = try await sentItems

                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }



        /// `await` MIGHT suspend itself
        /// The keyword marks that it CAN suspend itself for other work to happen
        func fetchInbox() async throws -> [Message] {
            let inboxURL = URL(string: "https://hws.dev/inbox.json")!
            return try await URLSession.shared.decode(from: inboxURL)
        }

        /// Added as part of the challenge
        func fetchSent() async throws -> [Message] {
            let inboxURL = URL(string: "https://hws.dev/sent.json")!
            return try await URLSession.shared.decode(from: inboxURL)
        }

        /// comparison method wihout `async`
//        func fetchInbox(completion: @escaping (Result<[Message], Error>) -> Void) {
//            let inboxURL = URL(string: "https://hws.dev/inbox.json")!
//
//            URLSession.shared.dataTask(with: inboxURL) { data, response, error in
//                if let data = data {
//                    if let messages = try? JSONDecoder().decode([Message].self, from: data) {
//                        completion(.success(messages))
//                    }
//                } else if let error = error {
//                    completion(.failure(error))
//                }
//            }.resume()
//
//        }

        /// wraps the old `non-async` code calls for completion based code
        /// And allows us to use the newer `async` syntax at the call site
//        func fetchInbox() async throws -> [Message] {
//            try await withCheckedThrowingContinuation { continuation in
//                fetchInbox { result in
//                    switch result {
//                        case .success(let messages):
//                            continuation.resume(returning: messages)
//                        case.failure(let error):
//                            continuation.resume(throwing: error)
//                    }
//                }
//            }
//        }

    }

    struct Day1_Session2_Previews: PreviewProvider {
        static var previews: some View {
            Day1_Session2()
        }
    }

}

