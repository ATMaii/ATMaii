
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fb{YourAppID}</string>
    </array>
  </dict>
</array>
<key>FacebookAppID</key>
<string>{YourAppID}</string>
<key>FacebookDisplayName</key>
<string>{YourDisplayName}</string>
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>fbapi</string>
  <string>fb-messenger-api</string>
  <string>fbauth2</string>
  <string>fbshareextension</string>
</array>

// MARK: - Models

import SwiftUI
import Foundation

enum Suit: String, CaseIterable {
    case hearts = "♥"
    case diamonds = "♦"
    case clubs = "♣"
    case spades = "♠"
}

enum Rank: Int, CaseIterable, Comparable {
    case two = 2, three, four, five, six, seven, eight, nine, ten
    case jack = 11, queen, king, ace = 14

    var display: String {
        switch self {
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        case .ace: return "A"
        default: return String(self.rawValue)
        }
    }

    static func < (lhs: Rank, rhs: Rank) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

struct Card: Identifiable, Equatable {
    let id = UUID()
    let suit: Suit
    let rank: Rank

    var display: String {
        return "\(rank.display)\(suit.rawValue)"
    }
}

// MARK: - Views

struct GameView: View {
    @StateObject private var gameLogic = GameLogic(playerNames: ["Player 1", "Player 2", "Player 3", "Player 4"])
    @State private var gameStarted = false
    @State private var isGameOver = false
    @State private var isGameActive = true
    @State private var timeRemaining = 120
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Text("Game: 3กอง")
                .font(.largeTitle)
                .padding()

            if !gameStarted {
                Button("เริ่มเกม") {
                    gameLogic.startNewGame()
                    gameStarted = true
                    startTimer()
                }
                .padding()
            }

            if gameStarted && isGameActive {
                let player3 = gameLogic.players[2] // ผู้เล่นหลัก

                VStack(spacing: 40) {
                    // แถวหัว กลาง ท้ายพร้อม DropArea
                    CardRowView(title: "หัว", cards: player3.headCards)
                        .dropDestination(for: Card.self) { items, location in
                            for item in items {
                                gameLogic.players[2].headCards.append(item)
                                gameLogic.players[2].unarrangedCards.removeAll { $0.id == item.id }
                            }
                            return true
                        }

                    CardRowView(title: "กลาง", cards: player3.middleCards)
                        .dropDestination(for: Card.self) { items, location in
                            for item in items {
                                gameLogic.players[2].middleCards.append(item)
                                gameLogic.players[2].unarrangedCards.removeAll { $0.id == item.id }
                            }
                            return true
                        }

                    CardRowView(title: "ท้าย", cards: player3.tailCards)
                        .dropDestination(for: Card.self) { items, location in
                            for item in items {
                                gameLogic.players[2].tailCards.append(item)
                                gameLogic.players[2].unarrangedCards.removeAll { $0.id == item.id }
                            }
                            return true
                        }

                    Divider()

                    // ไพ่ที่ยังไม่ได้จัด
                    Text("ไพ่ของคุณ")
                        .font(.headline)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(player3.unarrangedCards, id: \ .id) { card in
                                DraggableCard(card: card)
                                    .gesture(dragGesture(for: card))
                            }
                        }
                        .padding()
                    }

                    Button("เสร็จแล้ว") {
                        // บันทึกการจัดไพ่
                        isGameActive = false
                        isGameOver = true
                        timer?.invalidate()
                    }
                    .padding(.top)
                }
                .padding()

                Text("เวลาที่เหลือ: \(timeRemaining)")
            }
        }
    }

    private func dragGesture(for card: Card) -> some Gesture {
        DragGesture()
            .onEnded { value in
                let y = value.location.y
                if y < 200 {
                    gameLogic.players[2].headCards.append(card)
                } else if y < 400 {
                    gameLogic.players[2].middleCards.append(card)
                } else {
                    gameLogic.players[2].tailCards.append(card)
                }
                gameLogic.players[2].unarrangedCards.removeAll { $0.id == card.id }
            }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                isGameActive = false
                isGameOver = true
                autoArrangeCards()
            }
        }
    }

    private func autoArrangeCards() {
        var player = gameLogic.players[2]
        let sorted = player.unarrangedCards.sorted { $0.rank.rawValue > $1.rank.rawValue }

        player.headCards = Array(sorted.prefix(3))
        player.middleCards = Array(sorted.dropFirst(3).prefix(5))
        player.tailCards = Array(sorted.dropFirst(8).prefix(5))
        player.unarrangedCards = []

        gameLogic.players[2] = player
    }
}

// MARK: - Components

struct CardRowView: View {
    let title: String
    let cards: [Card]

    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
            HStack {
                ForEach(cards, id: \ .id) { card in
                    Text(card.display)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                }
            }
        }
    }
}

struct DraggableCard: View {
    let card: Card

    var body: some View {
        Text(card.display)
            .padding()
            .background(Color.yellow)
            .cornerRadius(8)
            .shadow(radius: 2)
            .onDrag {
                NSItemProvider(object: NSString(string: card.display))
            }
    }
}
เพิ่ม DropArea .dropDestination

// MARK: - Models

import SwiftUI
import Foundation

enum Suit: String, CaseIterable {
    case hearts = "♥"
    case diamonds = "♦"
    case clubs = "♣"
    case spades = "♠"
}

enum Rank: Int, CaseIterable, Comparable {
    case two = 2, three, four, five, six, seven, eight, nine, ten
    case jack = 11, queen, king, ace = 14

    var display: String {
        switch self {
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        case .ace: return "A"
        default: return String(self.rawValue)
        }
    }

    static func < (lhs: Rank, rhs: Rank) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

struct Card: Identifiable, Equatable {
    let id = UUID()
    let suit: Suit
    let rank: Rank

    var display: String {
        return "\(rank.display)\(suit.rawValue)"
    }
}

// MARK: - Views

struct GameView: View {
    @StateObject private var gameLogic = GameLogic(playerNames: ["Player 1", "Player 2", "Player 3", "Player 4"])
    @State private var gameStarted = false
    @State private var isGameOver = false
    @State private var isGameActive = true
    @State private var timeRemaining = 120
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Text("Game: 3กอง")
                .font(.largeTitle)
                .padding()

            if !gameStarted {
                Button("เริ่มเกม") {
                    gameLogic.startNewGame()
                    gameStarted = true
                    startTimer()
                }
                .padding()
            }

            if gameStarted && isGameActive {
                let player3 = gameLogic.players[2] // ผู้เล่นหลัก

                VStack(spacing: 40) {
                    // แถวหัว กลาง ท้ายพร้อม DropArea
                    CardRowView(title: "หัว", cards: player3.headCards)
                        .dropDestination(for: Card.self) { items, location in
                            for item in items {
                                gameLogic.players[2].headCards.append(item)
                                gameLogic.players[2].unarrangedCards.removeAll { $0.id == item.id }
                            }
                            return true
                        }

                    CardRowView(title: "กลาง", cards: player3.middleCards)
                        .dropDestination(for: Card.self) { items, location in
                            for item in items {
                                gameLogic.players[2].middleCards.append(item)
                                gameLogic.players[2].unarrangedCards.removeAll { $0.id == item.id }
                            }
                            return true
                        }

                    CardRowView(title: "ท้าย", cards: player3.tailCards)
                        .dropDestination(for: Card.self) { items, location in
                            for item in items {
                                gameLogic.players[2].tailCards.append(item)
                                gameLogic.players[2].unarrangedCards.removeAll { $0.id == item.id }
                            }
                            return true
                        }

                    Divider()

                    // ไพ่ที่ยังไม่ได้จัด
                    Text("ไพ่ของคุณ")
                        .font(.headline)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(player3.unarrangedCards, id: \ .id) { card in
                                DraggableCard(card: card)
                                    .gesture(dragGesture(for: card))
                            }
                        }
                        .padding()
                    }

                    Button("เสร็จแล้ว") {
                        // บันทึกการจัดไพ่
                        isGameActive = false
                        isGameOver = true
                        timer?.invalidate()
                    }
                    .padding(.top)
                }
                .padding()

                Text("เวลาที่เหลือ: \(timeRemaining)")
            }
        }
    }

    private func dragGesture(for card: Card) -> some Gesture {
        DragGesture()
            .onEnded { value in
                let y = value.location.y
                if y < 200 {
                    gameLogic.players[2].headCards.append(card)
                } else if y < 400 {
                    gameLogic.players[2].middleCards.append(card)
                } else {
                    gameLogic.players[2].tailCards.append(card)
                }
                gameLogic.players[2].unarrangedCards.removeAll { $0.id == card.id }
            }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                isGameActive = false
                isGameOver = true
                autoArrangeCards()
            }
        }
    }

    private func autoArrangeCards() {
        var player = gameLogic.players[2]
        let sorted = player.unarrangedCards.sorted { $0.rank.rawValue > $1.rank.rawValue }

        player.headCards = Array(sorted.prefix(3))
        player.middleCards = Array(sorted.dropFirst(3).prefix(5))
        player.tailCards = Array(sorted.dropFirst(8).prefix(5))
        player.unarrangedCards = []

        gameLogic.players[2] = player
    }
}

// MARK: - Components



struct CardRowView: View {
    let title: String
    let cards: [Card]

    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
            HStack {
                ForEach(cards, id: \ .id) { card in
                    Text(card.display)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                }
            }
        }
    }
}

struct DraggableCard: View {
    let card: Card

    var body: some View {
        Text(card.display)
            .padding()
            .background(Color.yellow)
            .cornerRadius(8)
            .shadow(radius: 2)
            .onDrag {
                NSItemProvider(object: NSString(string: card.display))
            }
    }
}

// MARK: - Models

import SwiftUI import Foundation

enum Suit: String, CaseIterable { case hearts = "♥" case diamonds = "♦" case clubs = "♣" case spades = "♠" }

enum Rank: Int, CaseIterable, Comparable { case two = 2, three, four, five, six, seven, eight, nine, ten case jack = 11, queen, king, ace = 14

var display: String {
    switch self {
    case .jack: return "J"
    case .queen: return "Q"
    case .king: return "K"
    case .ace: return "A"
    default: return String(self.rawValue)
    }
}

static func < (lhs: Rank, rhs: Rank) -> Bool {
    return lhs.rawValue < rhs.rawValue

// MARK: - Models

import SwiftUI
import Foundation

enum Suit: String, CaseIterable {
    case hearts = "♥"
    case diamonds = "♦"
    case clubs = "♣"
    case spades = "♠"
}

enum Rank: Int, CaseIterable, Comparable {
    case two = 2, three, four, five, six, seven, eight, nine, ten
    case jack = 11, queen, king, ace = 14

    var display: String {
        switch self {
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        case .ace: return "A"
        default: return String(self.rawValue)
        }
    }

    static func < (lhs: Rank, rhs: Rank) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

struct Card: Identifiable, Equatable {
    let id = UUID()
    let suit: Suit
    let rank: Rank

    var display: String {
        return "\(rank.display)\(suit.rawValue)"
    }
}
// MARK: - Models

import SwiftUI import Foundation

enum Suit: String, CaseIterable { case hearts = "♥" case diamonds = "♦" case clubs = "♣" case spades = "♠" }

enum Rank: Int, CaseIterable, Comparable { case two = 2, three, four, five, six, seven, eight, nine, ten case jack = 11, queen, king, ace = 14

var display: String {
    switch self {
    case .jack: return "J"
    case .queen: return "Q"
    case .king: return "K"
    case .ace: return "A"
    default: return String(self.rawValue)
    }
}

static func < (lhs: Rank, rhs: Rank) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

}

struct Card: Identifiable, Equatable { let id = UUID() let suit: Suit let rank: Rank

var display: String {
    return "


// MARK: - Views

// MARK: - Views

struct GameView: View {
    @StateObject private var gameLogic = GameLogic(playerNames: ["Player 1", "Player 2", "Player 3", "Player 4"])
    @State private var gameStarted = false
    @State private var isGameOver = false
    @State private var isGameActive = true
    @State private var timeRemaining = 120
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Text("Game: 3กอง")
                .font(.largeTitle)
                .padding()

            if !gameStarted {
                Button("เริ่มเกม") {
                    gameLogic.startNewGame()
                    gameStarted = true
                    startTimer()
                }
                .padding()
            }

            if gameStarted && isGameActive {
                let player3 = gameLogic.players[2] // ผู้เล่นหลัก

                VStack(spacing: 40) {
                    // แถวหัว (3 ช่อง)
                    CardRowView(title: "หัว", cards: player3.headCards)
                        .onDrop(of: [UTType.text], isTargeted: nil) { providers in
                            handleDrop(providers: providers, target: .head)
                        }

                    // แถวกลาง (5 ช่อง)
                    CardRowView(title: "กลาง", cards: player3.middleCards)
                        .onDrop(of: [UTType.text], isTargeted: nil) { providers in
                            handleDrop(providers: providers, target: .middle)
                        }

                    // แถวท้าย (5 ช่อง)
                    CardRowView(title: "ท้าย", cards: player3.tailCards)
                        .onDrop(of: [UTType.text], isTargeted: nil) { providers in
                            handleDrop(providers: providers, target: .tail)
                        }

                    Divider()

                    // ไพ่ที่ยังไม่ได้จัด
                    Text("ไพ่ของคุณ")
                        .font(.headline)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(player3.unarrangedCards, id: \.id) { card in
                                DraggableCard(card: card)
                                    .gesture(dragGesture(for: card))
                            }
                        }
                        .padding()
                    }

                    Button("เสร็จแล้ว") {
                        // บันทึกการจัดไพ่
                        isGameActive = false
                        isGameOver = true
                        timer?.invalidate()
                    }
                    .padding(.top)
                }
                .padding()

                Text("เวลาที่เหลือ:

    // เพิ่ม DropArea สำหรับแถว
struct DropArea: View {
    let title: String
    @Binding var cards: [Card]

    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
                .padding(.bottom, 8)
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 100)
                    .border(Color.black, width: 1)
                VStack {
                    ForEach(cards, id: \.id) { card in
                        Text(card.display)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                    }
                }
            }
        }
        .onDrop(of: [.text], isTargeted: nil) { providers in
            // ดึงข้อมูลเมื่อไพ่ถูกวาง
            if let item = providers.first {
                item.loadObject(ofClass: NSString.self) { (string, error) in
                    if let cardString = string as? String {
                        // สร้างไพ่จาก string
                        if let card = createCard(from: cardString) {
                            cards.append(card)
                        }
                    }
                }
            }
            return true
        }
    }

    private func createCard(from string: String) -> Card? {
        // ทำการแยก suit และ rank จาก string เพื่อสร้างไพ่
        if let rank = Rank.allCases.first(where: { $0.display == String(string.prefix(1)) }),
           let suit = Suit.allCases.first(where: { string.contains($0.rawValue) }) {
            return Card(suit: suit, rank: rank)
        }
        return nil
    }
}

// ใน GameView: แสดง DropArea แทนที่ Dragging
struct GameView: View {
    @StateObject private var gameLogic = GameLogic(playerNames: ["Player 1", "Player 2", "Player 3", "Player 4"])
    @State private var gameStarted = false
    @State private var isGameOver = false
    @State private var isGameActive = true
    @State private var timeRemaining = 120
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Text("Game: 3กอง")
                .font(.largeTitle)
                .padding()

            if !gameStarted {
                Button("เริ่มเกม") {
                    gameLogic.startNewGame()
                    gameStarted = true
                    startTimer()
                }
                .padding()
            }

            if gameStarted && isGameActive {
                let player3 = gameLogic.players[2] // ผู้เล่นหลัก

                VStack(spacing: 40) {
                    // ใช้ DropArea แทนที่ CardRowView
                    DropArea(title: "หัว", cards: $gameLogic.players[2].headCards)
                    DropArea(title: "กลาง", cards: $gameLogic.players[2].middleCards)
                    DropArea(title: "ท้าย", cards: $gameLogic.players[2].tailCards)

                    Divider()

                    // ไพ่ที่ยังไม่ได้จัด
                    Text("ไพ่ของคุณ")
                        .font(.headline)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(player3.unarrangedCards, id: \.id) { card in
                                DraggableCard(card: card)
                                    .gesture(dragGesture(for: card))
                            }
                        }
                        .padding()
                    }

                    Button("เสร็จแล้ว") {
                        // บันทึกการจัดไพ่
                        isGameActive = false
                        isGameOver = true
                        timer?.invalidate()
                    }
                    .padding(.top)
                }
                .padding()

                Text("เวลาที่เหลือ:

struct GameView: View {
    @StateObject private var gameLogic = GameLogic(playerNames: ["Player 1", "Player 2", "Player 3", "Player 4"])
    @State private var gameStarted = false
    @State private var isGameOver = false
    @State private var isGameActive = true
    @State private var timeRemaining = 120
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Text("Game: 3กอง")
                .font(.largeTitle)
                .padding()

            if !gameStarted {
                Button("เริ่มเกม") {
                    gameLogic.startNewGame()
                    gameStarted = true
                    startTimer()
                }
                .padding()
            }

            if gameStarted && isGameActive {
                let player3 = gameLogic.players[2] // ผู้เล่นหลัก

                VStack(spacing: 40) {
                    // แถวหัว กลาง ท้าย
                    CardRowView(title: "หัว", cards: player3.headCards)
                    CardRowView(title: "กลาง", cards: player3.middleCards)
                    CardRowView(title: "ท้าย", cards: player3.tailCards)

                    Divider()

                    // ไพ่ที่ยังไม่ได้จัด
                    Text("ไพ่ของคุณ")
                        .font(.headline)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(player3.unarrangedCards, id: \ .id) { card in
                                DraggableCard(card: card)
                                    .gesture(dragGesture(for: card))
                            }
                        }
                        .padding()
                    }

                    Button("เสร็จแล้ว") {
                        // บันทึกการจัดไพ่
                    }
                    .padding(.top)
                }
                .padding()

                Text("เวลาที่เหลือ: \(timeRemaining)")
            }
        }
    }

    private func dragGesture(for card: Card) -> some Gesture {
        DragGesture()
            .onEnded { value in
                let y = value.location.y
                if y < 200 {
                    gameLogic.players[2].headCards.append(card)
                } else if y < 400 {
                    gameLogic.players[2].middleCards.append(card)
                } else {
                    gameLogic.players[2].tailCards.append(card)
                }
                gameLogic.players[2].unarrangedCards.removeAll { $0.id == card.id }
            }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                isGameActive = false
                isGameOver = true
            }
        }
    }
}

// MARK: - Components

struct CardRowView: View {
    let title: String
    let cards: [Card]

    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
            HStack {
                ForEach(cards, id: \ .id) { card in
                    Text(card.display)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                }
            }
        }
    }
}

struct DraggableCard: View {
    let card: Card

    var body: some View {
        Text(card.display)
            .padding()
            .background(Color.yellow)
            .cornerRadius(8)
            .shadow(radius: 2)
            .onDrag {
                NSItemProvider(object: NSString(string: card.display))
            }
    }
}

