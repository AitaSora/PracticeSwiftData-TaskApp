

import SwiftData
import SwiftUI


struct TaskListingView: View {
    @Environment(\.modelContext) var context
    @Query(filter: #Predicate<Todo>{ $0.isDone == true }, sort: [SortDescriptor(\Todo.registerDate, order: .reverse)]) var sortTodos: [Todo]

    var body: some View {
        List {
            // ソートされたタスクをリスト表示
            ForEach(sortTodos) { todo in
                NavigationLink(value: todo) {
                    VStack(alignment: .leading) {
                        // タスクの内容を表示
                        Text(todo.content)
                            .font(.headline)

                        // タスクの終了日を表示
                        Text(todo.registerDate, format: Date.FormatStyle(date: .numeric))
                    }
                }
            }
            // タスクを削除
            .onDelete(perform: deleteTasks)
        }
    }

    // イニシャライザ: ソート条件と検索文字列を受け取り、タスクのクエリを設定
    init(sort: SortDescriptor<Todo>, searchString: String) {
        _sortTodos = Query(filter: #Predicate<Todo> {
            // 検索文字列が空の場合は、すべてのタスクを返す。そうでない場合は、検索文字列を含むタスクのみを返す。
            if searchString.isEmpty {
                return $0.isDone
            } else {
                return $0.isDone && $0.content.localizedStandardContains(searchString)
            }
        }, sort: [sort])
    }

    // deleteTasks: インデックスセットを受け取り、それに対応するタスクを削除
    func deleteTasks(_ indexSet: IndexSet) {
        for index in indexSet {
            let todo = sortTodos[index]
            context.delete(todo)
        }
    }
}
