// Copyright 2021 Masayuki Ishikawa <masayuki.ishikawa@gmail.com>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import SwiftUI

struct ContentView: View {
    @AppStorage("preset") var preset: Int = 300
    @AppStorage("theme") var theme: Int = 0
    @State var timeRemain = 0
    @State var timeOver = false
    @State var timerStarted = false

    @State var timeStr: String = "00:00"
    @State var txtColor = Color.black
    @State var ssBtnStr: String = "Start"
    @State var btnTxtColor = Color.black

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let sound = NSSound(named: "Blow")

    var body: some View {
        VStack {
            Text(timeStr)
                .font(.custom("Arial", size: 60))
                .foregroundColor(txtColor)
                .frame(width: 175, height:60)
                .padding(.top, -20)

            HStack {
                Button(action: ssAction) {
                    Text(ssBtnStr)
                        .frame(width: 40, height: 18)
                        .foregroundColor(btnTxtColor)
                }
                .padding()
                .padding(.top, -20)
                .padding(.bottom, -5)

                Button(action: rstAction) {
                    Text("Reset")
                        .frame(width: 40, height: 18)
                        .foregroundColor(btnTxtColor)
                }
                .padding()
                .padding(.top, -20)
                .padding(.bottom, -5)
                .disabled(timerStarted)
            }
        }
        .onReceive(timer) { _ in
            timerAction()
        }
        .onAppear {
            // Apply preset timer value
            updateRemain(val: preset, load: true)
            updateTimeStr()
        }
        .contextMenu {
            Picker(selection: $preset, label:Text("Preset timer")) {
                Text("00:10").tag(10)
                Text("03:00").tag(3 * 60)
                Text("05:00").tag(5 * 60)
                Text("10:00").tag(10 * 60)
                Text("15:00").tag(15 * 60)
                Text("20:00").tag(20 * 60)
                Text("25:00").tag(25 * 60)
                Text("30:00").tag(30 * 60)
            }
            // NOTE: onChange() event will not be generated for the 1st change
            // For the workaround, use onAppear() as well
            .onChange(of: preset) { tag in
                print("preset tag: \(tag)")
                updateRemain(val: preset, load: true)
                updateTimeStr()
                print("timeRemain: \(timeRemain)")
            }
            .onAppear {
                print("+++ preset: \($preset)")
                updateRemain(val: preset, load: true)
                updateTimeStr()
            }

            Picker(selection: $theme, label:Text("Theme")) {
                Text("Dark").tag(0)
                Text("Light").tag(1)
            }
            .onChange(of: theme) { tag in
                print("theme tag: \(tag)")
                updateTimeStr()
                updateBtn()
            }
            .onAppear {
                print("+++ theme: \($theme)")
                updateTimeStr()
                updateBtn()
            }

        }
        .background(Color.clear)
    }

    func ssAction() -> Void {
        if timerStarted == false {
            ssBtnStr = "Pause"
        } else {
            sound?.stop()
            ssBtnStr = "Start"
        }
        timerStarted.toggle()
    }

    func rstAction() -> Void {
        if timerStarted == false {
            timeOver = false
            timeRemain = preset
            updateTimeStr()
        }
    }

    func timerAction() -> Void{
        if timerStarted {
            if timeOver {
                updateRemain(val: 1)
            } else {
                updateRemain(val: -1)
            }

            if 0 == timeRemain {
                timeOver = true
                sound?.loops = true
                sound?.play()
            }
        }

        updateTimeStr()
    }

    func updateTimeStr() -> Void {
        if timeOver {
            txtColor = Color.red
        } else {
            if 0 == theme {
                // Dark
                txtColor = Color.black
            } else {
                // Light
                txtColor = Color.white
            }
        }

        timeStr = String(format: "%02d", timeRemain / 60)
            + ":" + String(format: "%02d", timeRemain % 60)
    }

    func updateBtn() -> Void{
        if 0 == theme {
            // Dark
            btnTxtColor = Color.black
        } else {
            // Light
            btnTxtColor = Color.white
        }
    }

    func updateRemain(val: Int, load: Bool = false) -> Void {
        if load {
            timeRemain = val
        } else {
            timeRemain += val
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
