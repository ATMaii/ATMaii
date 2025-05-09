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
