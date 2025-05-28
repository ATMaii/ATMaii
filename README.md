- 👋 Hi, I’m @ATMaii Anujit Trassaru Maii
- 👀 I’m interested in ...Something
- 🌱 I’m currently learning ...Coding
- 💞️ I’m looking to collaborate on ... Me
- 📫 How to reach me ... straight
- 😄 Pronouns: ... 
- ⚡ Fun fact: ... Ummmm

import SwiftUI

struct DeclarativeView: View {
    @State private var isOn = false

    var body: some View {
        VStack(spacing: 20) {
            Toggle("เปิด/ปิด", isOn: $isOn)
                .padding()

            Text(isOn ? "สวิตช์เปิดอยู่" : "สวิตช์ปิดอยู่")
                .font(.headline)
                .foregroundColor(isOn ? .green : .red)
        }
        .padding()
    }
}

struct DeclarativeView_Previews: PreviewProvider {
    static var previews: some View {
        DeclarativeView()
    }
}

<!---
ATMaii/ATMaii is a ✨ special ✨ repository because its `README.md` (this file) appears on your GitHub profile.
You can click the Preview link to take a look at your changes.
--->
