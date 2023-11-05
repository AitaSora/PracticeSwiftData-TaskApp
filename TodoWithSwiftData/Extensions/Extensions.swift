

import Foundation
import SwiftUI
import SwiftData

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

struct NavigationBarBackButtonTextHidden: ViewModifier {
  @Environment(\.presentationMode) var presentaion

  func body(content: Content) -> some View {
    content
      .navigationBarBackButtonHidden(true)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button(action: { presentaion.wrappedValue.dismiss() }) {
            Image(systemName: "arrowshape.turn.up.backward.fill")
          }
        }
      }
  }
}

extension View {
  func navigationBarBackButtonTextHidden() -> some View {
    return self.modifier(NavigationBarBackButtonTextHidden())
  }
}

struct NavigationBarBackButton2TextHidden: ViewModifier {
  @Environment(\.presentationMode) var presentaion

  func body(content: Content) -> some View {
    content
      .navigationBarBackButtonHidden(true)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button(action: { presentaion.wrappedValue.dismiss() }) {
            Image(systemName: "chevron.backward")
            Text("Completed Tasks")
          }
        }
      }
  }
}

extension View {
  func navigationBarBackButton2TextHidden() -> some View {
    return self.modifier(NavigationBarBackButton2TextHidden())
  }
}
