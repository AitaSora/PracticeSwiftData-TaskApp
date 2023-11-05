

import SwiftData
import SwiftUI

struct UndoTaskListingView: View {
    @Environment(\.modelContext) var context
    @Query var undoTodos: [Todo]

    var body: some View {
        List {
            ForEach(undoTodos.filter { !$0.isDone }) { todo in
                NavigationLink(value: todo) {
                    VStack(alignment: .leading) {
                        Text(" \(todo.content)")
                        Text(todo.goal)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    }
                }
            }
            .onDelete(perform: deleteTasks)
        }
    }

    func deleteTasks(_ indexSet: IndexSet) {
        for index in indexSet {
            let todo = undoTodos[index]
            context.delete(todo)
        }
    }
}

