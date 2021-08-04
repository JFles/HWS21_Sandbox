//
//  Day2_Session3.swift
//  Day2_Session3
//
//  Created by Jeremy Fleshman on 8/3/21.
//

import SwiftUI
import CryptoKit

/// Actors
/// `concrete nominal`
/// Reference types, like classes, but built for concurrency down to the compiler level
/// Guranteed that there are no data races - compiler will prevent this
/// No inheritance is allowed -- automatically conforms to `Actor` protocol
/// To access a variable outside of the actor, HAVE to use `await`
//actor User {
//    /// await must be used to read a `var` since it's a data race
//    var score = 10
//
//    func printScore() {
//        print("My score is \(score)")
//    }
//
//    /// must await to access another `actor`s `var` property
//    /// `let` is not an issue since its immutable
//    func copyScore(from other: User) async {
//        /// HAVE to `await` the result
//        score = await other.score
//    }
//}


/// Real world example of `Actor`
actor URLCache {
    /// Cannot read and write to cache dictionary at the same time
    /// `Actor` grants that protection
    private var cache = [URL: Data]()

    func data(for url: URL) async throws -> Data {
        if let cached = cache[url] {
            return cached
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        cache[url] = data
        return data
    }
}

/// classic CS example of bank accounts regarding parallel work, busy-waits
/// prevents race-conditions or double withdrwa from shared memory
actor BankAccount {
    var balance: Decimal

    init(initialBalance: Decimal) {
        self.balance = initialBalance
    }

    func deposit(amount: Decimal) {
        balance = balance + amount
    }

    /// making this async allows this to be protected from race conditions
    /// and prevents parallel errors without explicit locking needed
    func transfer(amount: Decimal, to other: BankAccount) async {
        guard balance >= amount else { return }
        balance = balance - amount
        await other.deposit(amount: amount)
    }
}

/// Simple example where `player` is an array of strings
/// Transfer players for a basketball team using Actor for the team, array for the players
actor SimpleTeam {
    var team: [String]

    init(initialTeam: [String]) {
        self.team = initialTeam
    }

    func add(player: String) {
        team.append(player)
    }

    func transfer(player: String, to otherTeam: SimpleTeam) async {
        // should there be a precondition check?
        guard let index = team.firstIndex(of: player) else { return }

        // remove the player from the team
        team.remove(at: index)

        // access the other team and add the player to the other team
        await otherTeam.add(player: player)
    }
}


/// harder problem for `actor` where `Player` is also an `actor`
actor Player: Hashable {
    let id: Int
    var name: String
    var salary: Decimal

    init(id: Int, name: String, salary: Decimal) {
        self.id = id
        self.name = name
        self.salary = salary
    }

    func offerRaise(amount: Decimal) {
        guard amount > 0 else {
            print("That's it, I quit!")
            return
        }

        salary += amount
    }

    static func ==(lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }

    nonisolated var hashValue: Int { id }

    /// conforming to hasher
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}

actor HardTeam {
    var team: [Player]

    init(initialTeam: [Player]) {
        self.team = initialTeam
    }

    func add(player: Player) {
        team.append(player)
    }

    func transfer(player: Player, to otherTeam: HardTeam) async {
        // should there be a precondition check?
        guard let index = team.firstIndex(of: player) else { return }

        // remove the player from the team
        team.remove(at: index)

        // access the other team and add the player to the other team
        await otherTeam.add(player: player)
    }
}

/// Replacing it with a `Set`
actor HardestTeam {
    var team: Set<Player>

    init(initialTeam: Set<Player>) {
        self.team = initialTeam
    }

    func add(player: Player) {
        team.insert(player)
    }

    func transfer(player: Player, to otherTeam: HardTeam) async {
        guard team.contains(player) else { return }
        team.remove(player)
        await otherTeam.add(player: player)
    }
}

/// `isolated` keyword example
actor DataStore {
    var username = "Anonymous"
    var friends = [String]()
    var highScores = [Int]()
    var favorites = Set<Int>()
}

func debugLog(dataStore: isolated DataStore) {
    print("Username: \(dataStore.username)")
    print("Friends: \(dataStore.friends)")
    print("highScores: \(dataStore.highScores)")
    print("favorites: \(dataStore.favorites)")
}

/// `nonisolated` example
actor User: Codable {
    let username: String
    let password: String
    var isOnline = false

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    nonisolated var passwordHash: String {
        let passwordData = Data(password.utf8)
        let hash = SHA256.hash(data: passwordData)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
    }
}



enum Day2_Session3 {
    
    /// `@MainActor` ensures all publishers, methods, etc are pushed to the Main thread for UI / user-interactive work
    @MainActor
    class ViewModel: ObservableObject {
        @Published var name = "Bob"
        @Published var isAuthenticated = false
    }

    struct Day2_Session3: View {
        @StateObject private var viewModel = ViewModel()

        var body: some View {
            Text("Hello, World!")
        }
    }

    struct Day2_Session3_Previews: PreviewProvider {
        static var previews: some View {
            Day2_Session3()
        }
    }
}
