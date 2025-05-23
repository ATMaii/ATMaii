- 👋 Hi, I’m @ATMaii Anujit Trassaru Maii
- 👀 I’m interested in ...Something
- 🌱 I’m currently learning ...Coding
- 💞️ I’m looking to collaborate on ... Me
- 📫 How to reach me ... straight
- 😄 Pronouns: ... 
- ⚡ Fun fact: ... Ummmm

import SwiftUI

struct ContentView: View {
    @State private var isLightOn = true

    var body: some View {
        ZStack {
            // พื้นหลังห้อง
            Color(isLightOn ? .white : .black)
                .animation(.easeInOut, value: isLightOn)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 40) {
                // หลอดไฟ
                Image(systemName: "lightbulb.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(isLightOn ? .yellow : .gray)
                    .animation(.easeInOut(duration: 0.5), value: isLightOn)

                // ปุ่มเปิด/ปิดไฟ
                Button(action: {
                    isLightOn.toggle()
                }) {
                    Text(isLightOn ? "Turn Off Light" : "Turn On Light")
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
        }
    }
}

<!---
ATMaii/ATMaii is a ✨ special ✨ repository because its `README.md` (this file) appears on your GitHub profile.
You can click the Preview link to take a look at your changes.
--->
