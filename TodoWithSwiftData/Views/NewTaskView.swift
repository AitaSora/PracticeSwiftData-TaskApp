

import SwiftUI
import SwiftData
import UserNotifications

// 新しいタスクを作成するビュー
struct NewTaskView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode
    @State private var textFieldInput = ""  // タスク名入力フィールドのテキスト
    @State private var goalFieldInput = ""  // タスクの説明入力フィールドのテキスト
    @State private var selectedPriority = 1  // 選択された優先度
    @State private var isNotificationEnabled = false  // 通知が有効かどうかの状態
    @State private var notificationTime = Date()  // 通知時間の設定
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // タスク名セクション
                Text("タスク名")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(Divider(), alignment: .bottom)
                    .onTapGesture {
                        dismissKeyboard()  // キーボードを非表示にする
                    }
                
                // タスク名入力フィールド
                TextField("Enter task", text: $textFieldInput)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray, lineWidth: 1))
                    .frame(width: 300)
                    .onTapGesture {
                        dismissKeyboard()
                    }
                
                // タスクの説明セクション
                Text("タスクの説明")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(Divider(), alignment: .bottom)
                    .onTapGesture {
                        dismissKeyboard()
                    }
                
                // タスクの説明入力フィールド
                TextEditor(text: $goalFieldInput)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray, lineWidth: 1))
                    .onTapGesture {
                        dismissKeyboard()
                    }
                    .frame(width: 300)
                    .frame(height: 180)
                
                // 優先度セクション
                Text("優先度")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(Divider(), alignment: .bottom)
                
                // 優先度選択ピッカー
                Picker("Priority", selection: $selectedPriority) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .colorMultiply(.green)
                .padding(.horizontal)
                
                // 通知設定トグル
                Toggle(isOn: $isNotificationEnabled) {
                    Text("通知を設定する")
                }.padding(.horizontal).padding(.top)
                
                // 通知時間設定（通知が有効の場合）
                if isNotificationEnabled {
                    DatePicker("通知時間", selection: $notificationTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(GraphicalDatePickerStyle()).padding(.horizontal)
                }
                
                // タスク追加ボタン
                Button(action: {
                    withAnimation {
                        add(todo: textFieldInput, goal: goalFieldInput, priority: selectedPriority, notificationEnabled: isNotificationEnabled, notificationTime: notificationTime)
                        presentationMode.wrappedValue.dismiss()  // ビューを閉じる
                    }
                }, label: {
                    Text("Add")
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(textFieldInput.isEmpty ? Color(UIColor.systemGray) : Color(UIColor.systemBlue))
                        .cornerRadius(8)
                        .shadow(color: textFieldInput.isEmpty ? Color.clear : Color(UIColor.systemGray4), radius: textFieldInput.isEmpty ? 0 : 10)
                })
                .disabled(textFieldInput.isEmpty)  // テキストフィールドが空の場合はボタンを無効化
            }
            .padding(.bottom)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("New Task")
                    .font(.custom("Papyrus", size: 24))
                    .foregroundColor(.primary)
            }
            
        }
        .onAppear(perform: requestNotificationPermission)  // ビューが表示された時に通知の許可を求める
    }
    
    // タスクを追加する関数
    private func add(todo: String, goal: String, priority: Int, notificationEnabled: Bool, notificationTime: Date) {
        let data = Todo(content: todo, goal: goal, priority: priority, notificationEnabled: notificationEnabled, notificationTime: notificationTime)
        context.insert(data)  // データを追加
        if notificationEnabled {
            scheduleNotification(todo: data)  // 通知をスケジュール
        }
    }
    
    // 通知の許可を求める関数
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            // 許可が得られたか、エラーが発生したかを処理
        }
    }
    
    // 通知をスケジュールする関数
    private func scheduleNotification(todo: Todo) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = todo.content
        content.body = "タスクを始めましょう！"
        content.sound = UNNotificationSound.default
        
        let notificationDate = todo.notificationTime
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}




