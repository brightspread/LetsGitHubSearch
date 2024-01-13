import XCTest

import ComposableArchitecture

@testable import GitHubSearch

@MainActor
final class RepositoryTests: XCTestCase {
    func test_user_get_repoSearchResults_when_search() async {
        // Arrange
        // TestStore를 생성합니다.
        let store = TestStore(
            initialState: RepoSearch.State(),
            reducer: RepoSearch()
        )

        // Act & Assert
        // 1. "Swift"를 입력했을 때, state.keyword가 "Swift"인지 테스트합니다.

        // testStore 는 대부분 async로 정의되어있음. 대부분 await
        await store.send(.keywordChanged("Swift")) { newState in
            newState.keyword = "Swift"
        }

        // 2. 검색을 했을 때, 예상하는 검색 결과가 나오는지를 테스트합니다.
        await store.send(.search) { newState in
            newState.searchResults = [
                "Swift",
                "SwiftJSON",
                "SwiftGuide",
                "SwiftterSwift",
            ]
        }

    }
}

