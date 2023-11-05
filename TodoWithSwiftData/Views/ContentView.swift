import SwiftUI
import SwiftData

// メインの ContentView。このビューは全てのタスクを優先度別にリスト表示します。
struct ContentView: View {
    
    @Environment(\.modelContext) private var context  // データモデルのコンテキストへの参照
    // 優先度別の未完了タスクのクエリ
    @Query(filter: #Predicate<Todo>{ !$0.isDone && $0.priority == 3}) private var highTodos: [Todo]
    @Query(filter: #Predicate<Todo>{ !$0.isDone && $0.priority == 2}) private var mediumTodos: [Todo]
    @Query(filter: #Predicate<Todo>{ !$0.isDone && $0.priority == 1}) private var lowTodos: [Todo]
    @State private var lastCheckedDate = Date()  // 現在の日付を保持するプロパティを追加
    @State private var refreshID = UUID()  // ビューを更新するトリガーとなるプロパティを追加
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List {
                        // 優先度別のタスクセクションを表示
                        PrioritySectionView(priority: 3, todos: highTodos, headerColor: .red, headerText: "高優先度")
                        PrioritySectionView(priority: 2, todos: mediumTodos, headerColor: .orange, headerText: "中優先度")
                        PrioritySectionView(priority: 1, todos: lowTodos, headerColor: .green, headerText: "低優先度")
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        // 削除済みタスクのビューへのリンク
                        NavigationLink(destination: DeletedTasksView()) {
                            Image(systemName: "tray.2")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding(10)
                                .foregroundColor(.primary)
                                .background(Circle().fill(Color(UIColor.secondarySystemBackground)))
                                .padding(15)
                                .shadow(color: Color(UIColor.systemGray4), radius: 10)
                        }
                        Spacer()
                        // 新しいタスク作成ビューへのリンク
                        NavigationLink(destination: NewTaskView()) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue)
                                .padding(20)
                                .shadow(color: Color(UIColor.systemGray4), radius: 10)
                        }
                    }
                    .padding(.bottom)
                }
            }
            .navigationTitle("Task List")
            .navigationBarTitleDisplayMode(.inline)  // ナビゲーションバーのタイトル表示モードを設定
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Task List")
                        .font(.custom("Papyrus", size: 24))
                        .foregroundColor(.primary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    // 現在の日付を表示
                    Text(dateString(from: lastCheckedDate))
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundColor(.primary)
                }
            }
        }
        .onAppear(perform: setupDateCheckTimer)  // ビューが表示されたときにタイマーを設定
        .id(refreshID)  // refreshID が変わるたびにビューを更新
        
    }
    
    // 日付を文字列に変換するメソッド
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        return formatter.string(from: date)
    }
    
    private func setupDateCheckTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let now = Date()
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: now)
            let lastCheckedDay = calendar.startOfDay(for: self.lastCheckedDate)
            
            if today != lastCheckedDay {
                self.refreshID = UUID()  // 日付が変わった場合、refreshID を更新してビューを再描画
            }
            
            self.lastCheckedDate = now  // lastCheckedDate を更新
        }
    }
}


// フッターのビュー。リストの下に余白を追加します。
var footerView: some View {
    Spacer()
        .frame(height: 100)  // ここで余白の高さを調整
}

// PrioritySectionView。優先度別のタスクセクションを表示するビューです。
struct PrioritySectionView: View {
    @Environment(\.modelContext) private var context  // データモデルのコンテキストへの参照
    var priority: Int  // タスクの優先度
    var todos: [Todo]  // 表示するタスクの配列
    var headerColor: Color  // セクションヘッダーの色
    var headerText: String  // セクションヘッダーのテキスト
    
    var body: some View {
        Section(header: Text(headerText).foregroundColor(headerColor).font(.headline)) {
            // 各タスクを表示
            ForEach(todos) { todo in
                NavigationLink {
                    TaskDetailView(todo: todo)
                } label: {
                    VStack(alignment: .leading) {
                        Text(" \(todo.content)")
                        if Calendar.current.isDateInToday(todo.registerDate) == false{
                            Text("\(dateString(from: todo.registerDate))のタスク")  // 日付を表示
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }else if !todo.goal.isEmpty {  // タスクの説明が空でない場合にのみ表示
                            Text(todo.goal)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(2)
                        }
                    }
                }
                .overlay(
                    Group {
                        if Calendar.current.isDateInToday(todo.registerDate) == false {
                            Rectangle()
                                .fill(Color.clear)
                                .stroke(headerColor.opacity(0.2), lineWidth: 50)
                        }
                    }
                )
            }
            .onDelete(perform: { indexSet in
                withAnimation {
                    // タスクを削除
                    for index in indexSet {
                        delete(todo: todos[index])
                    }
                }
            })
        }
    }
    
    // タスクを削除するメソッド
    private func delete(todo: Todo) {
        context.delete(todo)
    }
    // 日付を文字列に変換するメソッド
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        return formatter.string(from: date)
    }
}
#Preview {
    ContentView()
}



