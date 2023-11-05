import SwiftUI

struct RatingAndReflectionView: View {
    @Bindable var todo: Todo
    @State private var rating: Int = 3
    @State private var reflection: String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        ScrollView {  // ScrollViewを追加
            VStack(spacing: 20) {
                // タイトルを追加
                Text("Rate and Reflect")
                    .font(.custom("Papyrus", size: 24))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                Text("タスクの評価")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(Divider(), alignment: .bottom)
                RatingView(rating: $rating)
                Text("タスクの反省点")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(Divider(), alignment: .bottom)
                    .onTapGesture {
                        dismissKeyboard()
                    }
                TextEditor(text: $reflection)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray, lineWidth: 1))
                    .frame(width: 300, height: 220)
                    .onTapGesture {
                        dismissKeyboard()
                    }
                Button(action: {
                    todo.rating = rating
                    todo.reflection = reflection
                    todo.isDone = true
                    todo.registerDate = Date()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Submit")
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .shadow(color: Color(UIColor.systemGray4), radius: 10)
                }
            }
            .padding()
        }
        //        .navigationBarTitle("Rate and Reflect", displayMode: .inline)
        //        .toolbar {
        //            ToolbarItem(placement: .principal) {
        //                Text("Rate and Reflect")
        //                    .font(.custom("Papyrus", size: 24))
        //                    .foregroundColor(.primary)
        //            }
        //        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct RatingView: View {
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1..<6) { index in
                Image(systemName: rating >= index ? "star.fill" : "star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(rating >= index ? Color.yellow : .gray)
                    .onTapGesture {
                        rating = index
                    }
            }
        }
    }
}

