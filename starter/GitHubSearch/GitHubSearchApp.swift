import SwiftUI

import ComposableArchitecture

@main
struct GitHubSearchApp: App {
  var body: some Scene {
    WindowGroup {
      RepoSearchView(
        store: Store(
            initialState: RepoSearch.State(),
            reducer: RepoSearch()._printChanges()) // printChanges App에서 바뀐 것들이 출력됨
      )
    }
  }
}
