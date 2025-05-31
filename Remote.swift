import SwiftUI

@main struct UniversalRemoteApp: App { var body: some Scene { WindowGroup { UniversalRemoteView() } } }

struct UniversalRemoteView: View { @State private var message = "พร้อมเชื่อมต่ออุปกรณ์"

func sendCommand(_ command: String) {
    message = "ส่งคำสั่ง:

import SwiftUI

@main
struct UniversalRemoteApp: App {
    var body: some Scene {
        WindowGroup {
            UniversalRemoteView()
        }
    }
}

struct UniversalRemoteView: View {
    @State private var message = "พร้อมเชื่อมต่ออุปกรณ์"

    func sendCommand(_ command: String) {
        message = "ส่งคำสั่ง: \(command)"
        print(">> คำสั่ง: \(command)")
        // TODO: เชื่อมต่อ Wi-Fi / Bluetooth / IR และส่งคำสั่งจริง
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("🔧 Universal Remote")
                .font(.largeTitle)
                .bold()

            Text(message)
                .foregroundColor(.gray)
                .padding()

            HStack(spacing: 20) {
                RemoteButton(title: "Power", color: .red) {
                    sendCommand("Power")
                }
                RemoteButton(title: "Mute", color: .gray) {
                    sendCommand("Mute")
                }
            }

            HStack(spacing: 20) {
                RemoteButton(title: "Vol +", color: .blue) {
                    sendCommand("VolumeUp")
                }
                RemoteButton(title: "Vol -", color: .blue) {
                    sendCommand("VolumeDown")
                }
            }

            HStack(spacing: 20) {
                RemoteButton(title: "Ch +", color: .green) {
                    sendCommand("ChannelUp")
                }
                RemoteButton(title: "Ch -", color: .green) {
                    sendCommand("ChannelDown")
                }
            }
        }
        .padding()
    }
}

struct RemoteButton: View {
    var title: String
    var color: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(width: 80, height: 50)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}
