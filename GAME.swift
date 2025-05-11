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

