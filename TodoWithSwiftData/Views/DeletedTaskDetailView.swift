

import Foundation
import SwiftData
import SwiftUI

// DeletedTaskDetailView: このビューは削除されたタスクの詳細を表示
struct DeletedTaskDetailView: View {
    var todo: Todo  // 表示するタスクのデータ
    
    var body: some View {
        ScrollView {  // スクロール可能なビューを提供
            VStack(alignment: .leading, spacing: 20) {  // 垂直に配置されたビューグループ
                // タスク名セクション
                Group {
                    Text("タスク名")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .overlay(Divider(), alignment: .bottom)  // 下部に区切り線を表示
                    Text(todo.content)  // タスク名を表示
                        .padding([.leading, .trailing])
                        .font(.subheadline)
                }
                
                // タスク説明セクション
                Group {
                    Text("タスクの説明")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .overlay(Divider(), alignment: .bottom)
                    ScrollView {
                        Text(todo.goal)  // タスクの説明を表示
                            .padding([.leading, .trailing])
                            .font(.subheadline)
                    }
                    .frame(height: 100)
                    .cornerRadius(8)
                }
                
                // タスク評価セクション
                Group {
                    Text("タスクの評価")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .overlay(Divider(), alignment: .bottom)
                    HStack {
                        // 星評価を表示（最大5つ）
                        ForEach(0..<5) { index in
                            Image(systemName: (todo.rating ?? 0) > index ? "star.fill" : "star")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor((todo.rating ?? 0) > index ? .yellow : .gray)
                        }
                    }
                    .padding([.leading, .trailing])
                }
                
                // タスク反省セクション（存在する場合）
                if let reflection = todo.reflection {
                    Group {
                        Text("タスクの反省点")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .overlay(Divider(), alignment: .bottom)
                        ScrollView {
                            Text(reflection)  // 反省点を表示
                                .padding([.leading, .trailing])
                                .font(.subheadline)
                        }
                        .frame(height: 100)
                        .cornerRadius(8)
                    }
                }
                
                // 完了日付セクション
                Group {
                    Text("完了日付")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .overlay(Divider(), alignment: .bottom)
                    Text(todo.registerDate, format: Date.FormatStyle(date: .numeric))  // 完了日付を表示
                        .padding([.leading, .trailing])
                        .font(.subheadline)
                }
                
            }
            .padding()
            .padding(.bottom)  // 追加のパディングを下部に提供
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonTextHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Task Reflection")
                    .font(.custom("Papyrus", size: 24))
                    .foregroundColor(.primary)
            }
            
        }
    }
}
