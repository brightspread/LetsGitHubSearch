import Foundation

import ComposableArchitecture

// Reducer 모델링
struct RepoSearch: ReducerProtocol {
    struct State: Equatable {
        // TODO: 지금 앱은 어떤 상태들로 정의되는가?
        // keyword와 searchResults 상태 추가하기
        var keyword = ""
        var searchResults = [String]()
    }

    enum Action: Equatable {
        // TODO: 상태들을 변화시키는 사용자의 액션은 무엇인가?
        // keywordChanged, search 액션 추가하기
        case keywordChanged(String)
        case search
        case dataLoaded(TaskResult<RepositoryModel>)
    }

    @Dependency(\.repoSearchClient) var repoSearchClient
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        // TODO: 각각의 Action이 발생했을 때 상태는 어떻게 변화해야 하는가?
        switch action {
            case let .keywordChanged(keyword):
                state.keyword = keyword
                return .none // side effect 없음

            case .search:
                // 외부 로직 실행
                return EffectTask.run { [keyword = state.keyword] send in // concurrently-excuting 코드에서 캡처 불가
                    let result = await TaskResult {
                        try await repoSearchClient.search(keyword)
                    }
                    await send(.dataLoaded(result))
                    //try await sampleSearchRequest(keyword: keyword, send: send)
                }

            case let .dataLoaded(.success(repositoryModel)):
                state.searchResults = repositoryModel.items.map { $0.name }
                return .none

            case .dataLoaded(.failure):
                state.searchResults = []
                return .none
        }
    }

//    func sampleSearchRequest(keyword: String, send: Send<RepoSearch.Action>) async throws {
//      guard let url = URL(string: "https://api.github.com/search/repositories?q=\(keyword)") else {
//        await send(RepoSearch.Action.dataLoaded(.failure(APIError.invalidURL)))
//        return
//      }
//      let (data, _) = try await URLSession.shared.data(from: url)
//      let result = await TaskResult { try JSONDecoder().decode(RepositoryModel.self, from: data) }
//
//      await send(RepoSearch.Action.dataLoaded(result))
//    }

}
