import SwiftUI

import ComposableArchitecture

struct RepoSearchView: View {
    let store: StoreOf<RepoSearch>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    Text("Req count : \(viewStore.requestCount)")
                    
                    List {
                        ForEach(viewStore.searchResults, id: \.self) { Text($0) }
                    }
                    .searchable(
                        text: Binding(
                            get: { viewStore.keyword },
                            set: {
                                viewStore.send(
                                    .keywordChanged($0)
                                )
                            }
                        )
                    )
                }
                .navigationTitle("Github Search")
            }
        }
    }
}

struct RepoSearchView_Previews: PreviewProvider {
    static var previews: some View {
        RepoSearchView(
            store: Store(
                initialState: RepoSearch.State(),
                reducer: RepoSearch()
            )
        )
    }
}
