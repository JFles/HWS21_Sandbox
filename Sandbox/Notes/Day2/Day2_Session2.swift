//
//  Day2_Session2.swift
//  Day2_Session2
//
//  Created by Jeremy Fleshman on 8/3/21.
//

import SwiftUI

/// Demo func for `TaskGroup`
func printMessage_d2s2() async {
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

enum Day2_Session2 {

    struct Message: Codable, Identifiable {
        let id: Int
        let user: String
        let text: String
    }

    struct Day2_Session2: View {
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
                    do {
                        inbox = try await withThrowingTaskGroup(of: [Message].self) { group -> [Message] in
                            for i in 1...3 {
                                group.addTask {
                                    let url = URL(string: "https://hws.dev/inbox-\(i).json")!
                                    let (data, _) = try await URLSession.shared.data(from: url)
                                    return try JSONDecoder().decode([Message].self, from: data)
                                }
                            }

                            let allMessages = try await group.reduce(into: [Message]()) { $0 += $1}
                            return allMessages.sorted { $0.id < $1.id}
                        }

                        let sentTask = Task { () -> [Message] in
                            return try await fetchSent()
                        }

                        sent = try await sentTask.value
                    } catch {
                        print(error.localizedDescription)
                    }
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
    
    struct Day2_Session2_Previews: PreviewProvider {
        static var previews: some View {
            Day2_Session2()
        }
    }
}

