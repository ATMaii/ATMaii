import SwiftUI

struct GameView: View { @StateObject private var gameLogic = GameLogic(playerNames: ["Player 1", "Player 2", "Player 3", "Player 4"]) @State private var gameStarted = false @State private var timeRemaining = 120 @State private var timer: Timer? @State private var isGameOver = false @State private var isGameActive = true

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
            Text("เวลาที่เหลือ:


import SwiftUI

// Define the card set and result for each player
struct CardSet {
    var head: [String]
    var middle: [String]
    var bottom: [String]
    var score: Int
}

struct Player {
    var name: String
    var cardSet: CardSet
}

class CardGameModel: ObservableObject {
    @Published var players: [Player] = []
    
    // Function to calculate score between two sets
    func calculateScore(player1: CardSet, player2: CardSet) -> Int {
        var score = 0
        
        // Comparing head
        if player1.head == player2.head {
            score += 1
        } else if player1.head > player2.head {
            score += 2
        } else {
            score -= 1
        }
        
        // Comparing middle
        if player1.middle == player2.middle {
            score += 1
        } else if player1.middle > player2.middle {
            score += 2
        } else {
            score -= 1
        }
        
        // Comparing bottom
        if player1.bottom == player2.bottom {
            score += 1
        } else if player1.bottom > player2.bottom {
            score += 2
        } else {
            score -= 1
        }
        
        return score
    }
}

struct ContentView: View {
    @ObservedObject var gameModel = CardGameModel()
    
    var body: some View {
        VStack {
            ForEach(gameModel.players, id: \.name) { player in
                Text(player.name)
                    .font(.headline)
                    .padding()
                
                Text("Head:


import SwiftUI

struct ContentView: View {
    @State private var player1Score = 0
    @State private var player2Score = 0
    @State private var player3Score = 0
    @State private var player4Score = 0
    
    // โค้ดนี้คำนวณคะแนนของแต่ละชุด
    func calculateScore(player1Hand: [Card], player2Hand: [Card], player3Hand: [Card], player4Hand: [Card]) {
        let score1 = compareHands(player1Hand, player2Hand) // ชุดที่ 1 กับ ชุดที่ 2
        let score2 = compareHands(player1Hand, player3Hand) // ชุดที่ 1 กับ ชุดที่ 3
        let score3 = compareHands(player1Hand, player4Hand) // ชุดที่ 1 กับ ชุดที่ 4
        
        player1Score = score1 + score2 + score3
        
        let score4 = compareHands(player2Hand, player3Hand) // ชุดที่ 2 กับ ชุดที่ 3
        let score5 = compareHands(player2Hand, player4Hand) // ชุดที่ 2 กับ ชุดที่ 4
        
        player2Score = score4 + score5
        
        let score6 = compareHands(player3Hand, player4Hand) // ชุดที่ 3 กับ ชุดที่ 4
        
        player3Score = score6
        
        // คำนวณคะแนนสุดท้ายของ Player 4
        player4Score = score1 + score2 + score3 + score4 + score5 + score6
    }
    
    func compareHands(_ hand1: [Card], _ hand2: [Card]) -> Int {
        // เปรียบเทียบชุดไพ่ระหว่าง 2 ชุด
        // ตัวอย่างเช่น หาก hand1 ชนะ hand2 ให้ return +1, แพ้ return -1, เสมอ return 0
        // สามารถเพิ่มเงื่อนไขต่างๆ เช่น เปรียบเทียบตามลำดับไพ่
        return (hand1.count > hand2.count) ? 1 : (hand1.count < hand2.count ? -1 : 0)
    }
    
    var body: some View {
        VStack {
            Text("Player 1 Score:

ตัวอย่างการปรับโค้ดให้รองรับกติกาใหม่:

สมมติว่าคุณเปลี่ยนเป็นการเปรียบเทียบที่ต้องใช้ "4 ชั้น" แทน "3 ชั้น" 
หรือไพ่บางประเภทต้องใช้เงื่อนไขเฉพาะ เช่น ไพ่ "ตอง" หรือ "คู่ใหญ่" เป็นต้น:

struct Player {
    var name: String
    var hand: [Card]
    var score: Int = 0
}

struct Card {
    var rank: String
    var suit: String
}

func calculateScore(player1: Player, player2: Player) -> Int {
    // สมมุติว่ามีฟังก์ชันการจัดลำดับชุดไพ่ตามประเภท
    let player1Score = calculateHandScore(player1.hand)
    let player2Score = calculateHandScore(player2.hand)
    
    if player1Score > player2Score {
        return 1 // Player 1 ชนะ
    } else if player1Score < player2Score {
        return -1 // Player 2 ชนะ
    } else {
        return 0 // เสมอ
    }
}

func calculateHandScore(_ hand: [Card]) -> Int {
    // สมมุติว่าเรามีการจัดลำดับชุดไพ่ที่ใช้ในกติกาของเรา
    // ในที่นี้ใช้การนับไพ่ตามกฎใหม่ เช่น ตอง, คู่ใหญ่ ฯลฯ
    var score = 0
    // ตัวอย่าง การเปรียบเทียบไพ่แบบ "ตอง" และ "คู่"
    let groupedCards = groupCardsByRank(hand)
    for group in groupedCards {
        if group.count == 3 {
            score += 3 // ตอง
        } else if group.count == 2 {
            score += 2 // คู่
        }
    }
    
    return score
}

func groupCardsByRank(_ hand: [Card]) -> [[Card]] {
    // ฟังก์ชันนี้จะช่วยจัดกลุ่มไพ่ที่มีแต้มเหมือนกัน
    var grouped: [[Card]] = []
    
    for card in hand {
        if let index = grouped.firstIndex(where: { $0.first?.rank == card.rank }) {
            grouped[index].append(card)
        } else {
            grouped.append([card])
        }
    }
    
    return grouped
}

UI
import SwiftUI

struct ContentView: View {
    @State private var player1Score = 0
    @State private var player2Score = 0

    var body: some View {
        VStack {
            Text("Player 1 Score:
UI
import SwiftUI

struct ContentView: View {
    @State private var player1Score = 0
    @State private var player2Score = 0

    var body: some View {
        VStack {
            Text("Player 1 Score:

หมู 
import SwiftUI

struct ContentView: View {
    @State private var player1Score = 0
    @State private var player2Score = 0
    @State private var player3Score = 0
    @State private var player4Score = 0
    
    // โค้ดนี้คำนวณคะแนนของแต่ละชุด
    func calculateScore(player1Hand: [Card], player2Hand: [Card], player3Hand: [Card], player4Hand: [Card]) {
        let score1 = compareHands(player1Hand, player2Hand) // ชุดที่ 1 กับ ชุดที่ 2
        let score2 = compareHands(player1Hand, player3Hand) // ชุดที่ 1 กับ ชุดที่ 3
        let score3 = compareHands(player1Hand, player4Hand) // ชุดที่ 1 กับ ชุดที่ 4
        
        player1Score = score1 + score2 + score3
        
        let score4 = compareHands(player2Hand, player3Hand) // ชุดที่ 2 กับ ชุดที่ 3
        let score5 = compareHands(player2Hand, player4Hand) // ชุดที่ 2 กับ ชุดที่ 4
        
        player2Score = score4 + score5
        
        let score6 = compareHands(player3Hand, player4Hand) // ชุดที่ 3 กับ ชุดที่ 4
        
        player3Score = score6
        
        // คำนวณคะแนนสุดท้ายของ Player 4
        player4Score = score1 + score2 + score3 + score4 + score5 + score6
    }
    
    func compareHands(_ hand1: [Card], _ hand2: [Card]) -> Int {
        // เปรียบเทียบชุดไพ่ระหว่าง 2 ชุด
        // ตัวอย่างเช่น หาก hand1 ชนะ hand2 ให้ return +1, แพ้ return -1, เสมอ return 0
        // สามารถเพิ่มเงื่อนไขต่างๆ เช่น เปรียบเทียบตามลำดับไพ่
        return (hand1.count > hand2.count) ? 1 : (hand1.count < hand2.count ? -1 : 0)
    }
    
    var body: some View {
        VStack {
            Text("Player 1 Score:

import SwiftUI

struct ContentView: View {
    @State private var player1Score = 0
    @State private var player2Score = 0
    @State private var player3Score = 0
    @State private var player4Score = 0
    
    // เปรียบเทียบแต่ละชั้น
    func compareHands(_ hand1: [Card], _ hand2: [Card]) -> Int {
        // ตัวอย่างการเปรียบเทียบไพ่
        // แค่เปรียบเทียบจำนวนไพ่ในชุด ถ้ามีจำนวนมากกว่าชนะ
        return (hand1.count > hand2.count) ? 1 : (hand1.count < hand2.count ? -1 : 0)
    }
    
    func calculateScore(player1Top: [Card], player1Middle: [Card], player1Bottom: [Card],
                        player2Top: [Card], player2Middle: [Card], player2Bottom: [Card],
                        player3Top: [Card], player3Middle: [Card], player3Bottom: [Card],
                        player4Top: [Card], player4Middle: [Card], player4Bottom: [Card]) {
        
        let score1 = compareHands(player1Top, player2Top) + compareHands(player1Middle, player2Middle) + compareHands(player1Bottom, player2Bottom)
        let score2 = compareHands(player1Top, player3Top) + compareHands(player1Middle, player3Middle) + compareHands(player1Bottom, player3Bottom)
        let score3 = compareHands(player1Top, player4Top) + compareHands(player1Middle, player4Middle) + compareHands(player1Bottom, player4Bottom)
        
        player1Score = score1 + score2 + score3
        
        let score4 = compareHands(player2Top, player3Top) + compareHands(player2Middle, player3Middle) + compareHands(player2Bottom, player3Bottom)
        let score5 = compareHands(player2Top, player4Top) + compareHands(player2Middle, player4Middle) + compareHands(player2Bottom, player4Bottom)
        
        player2Score = score4 + score5
        
        let score6 = compareHands(player3Top, player4Top) + compareHands(player3Middle, player4Middle) + compareHands(player3Bottom, player4Bottom)
        
        player3Score = score6
        
        // คะแนนสุดท้ายของ Player 4
        player4Score = score1 + score2 + score3 + score4 + score5 + score6
    }
    
    var body: some View {
        VStack {
            Text("Player 1 Score:
