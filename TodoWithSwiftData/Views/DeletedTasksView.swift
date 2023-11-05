
import SwiftUI

struct DeletedTasksView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var path = [Todo]()
    @State private var sortOrder = SortDescriptor(\Todo.registerDate, order: .reverse)
    @State private var searchText = ""  // 検索テキスト
    @State private var showRatingView = false  // レーティングビューを表示するかどうか
    
    
    
    var body: some View {
        NavigationStack(path: $path) {
            TaskListingView(sort: sortOrder, searchString: searchText)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Completed Tasks")
                            .font(.custom("Papyrus", size: 24))
                            .foregroundColor(.primary)
                    }
                }
                .navigationDestination(for: Todo.self, destination: DeletedTaskDetailView.init)
                .searchable(text: $searchText)
            
        }
    }
    
    private func delete(todo: Todo) {
        context.delete(todo)
    }
    
    
}

