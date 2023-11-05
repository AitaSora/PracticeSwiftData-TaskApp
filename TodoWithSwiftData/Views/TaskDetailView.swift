

import SwiftUI
import UserNotifications

// タスク詳細画面を表示するビュー
struct TaskDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>  // プレゼンテーションモードへのアクセスを提供
    @Bindable var todo: Todo  // 表示するタスクのデータ
    @State private var showRatingView = false  // 評価ビューの表示状態
    @State private var showingConfirmation = false  // 確認アラートの表示状態
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack {
                    VStack(alignment: .leading, spacing: 20) {
                        
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
                        TextField("タスク名を入力", text: $todo.content)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray, lineWidth: 1))
                            .padding([.leading, .trailing])
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
                        
                        // タスク説明入力フィールド
                        TextEditor(text: $todo.goal)
                            .padding()
                            .frame(height: 180)
                            .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray, lineWidth: 1))
                            .onTapGesture {
                                dismissKeyboard()
                            }
                            .padding([.leading, .trailing])
                        
                        // 優先度セクション
                        Text("優先度")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .overlay(Divider(), alignment: .bottom)
                            .onTapGesture {
                                dismissKeyboard()
                            }
                        Picker("Priority", selection: $todo.priority) {
                            Text("Low").tag(1)
                            Text("Medium").tag(2)
                            Text("High").tag(3)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .colorMultiply(.green)
                        .padding(.horizontal)
                        
                        // 通知設定トグル
                        Toggle(isOn: $todo.notificationEnabled) {
                            Text("通知を設定する")
                        }.padding(.horizontal).padding(.top)
                        .onChange(of: todo.notificationEnabled) {
                            updateNotification(todo: todo)  // 通知を更新
                        }
                        
                        // 通知時間設定（通知が有効の場合）
                        if todo.notificationEnabled {
                            DatePicker("通知時間", selection: $todo.notificationTime, displayedComponents: .hourAndMinute)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding(.horizontal)
                                .onChange(of: todo.notificationTime) {
                                    updateNotification(todo: todo)
                                }
                        }
                        
                        Spacer()  // 余白を提供
                    }
                    
                    // 完了ボタンセクション
                    HStack {
                        Spacer()

                        Button(action: {
                            self.showingConfirmation = true  // 確認アラートを表示
                        }) {
                            Text("Complete")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color(UIColor.systemRed))
                                .cornerRadius(10)
                                .padding(.vertical)
                                .shadow(color: Color(UIColor.systemGray4), radius: 10)
                        }
                        .alert(isPresented: $showingConfirmation) {
                            Alert(
                                title: Text("確認"),
                                message: Text("本当にこのタスクを終了しますか？"),
                                primaryButton: .destructive(Text("Complete")) {
                                    self.showRatingView = true  // 評価ビューを表示
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        .sheet(isPresented: $showRatingView) {
                            RatingAndReflectionView(todo: todo)  // モーダルビューとして評価ビューを表示
                        }
                        Spacer()
                    }
                    .padding(.bottom)
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Task Detail")
                                    .font(.custom("Papyrus", size: 24))
                                    .foregroundColor(.primary)
                            }
                        }
        }
    }
    
    // 通知を更新する関数
    private func updateNotification(todo: Todo) {
        // 通知センターのアクセス
        let center = UNUserNotificationCenter.current()
        let notificationId = "\(todo.content)-\(todo.registerDate)"
        
        if todo.notificationEnabled {
            // 通知コンテンツの設定
            let content = UNMutableNotificationContent()
            content.title = todo.content
            content.body = "時間になりました！タスクを始めましょう！"
            content.sound = UNNotificationSound.default
            
            let notificationDate = todo.notificationTime
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
            center.add(request)
        } else {
            // 通知をキャンセル
            center.removePendingNotificationRequests(withIdentifiers: [notificationId])
        }
    }
    
    // キーボードを非表示にする関数
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
