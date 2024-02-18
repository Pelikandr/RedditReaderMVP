//
//  FeedPresenterTests.swift
//  RedditReaderMVPTests
//
//  Created by Denys Zaiakin on 18.02.2024.
//

import XCTest
@testable import RedditReaderMVP

private enum TestError: Error {
    case test
}

final class FeedPresenterTests: XCTestCase {

    var sut: FeedPresenter!
    private var network: MockNetworkManager!

    override func setUpWithError() throws {
        network = MockNetworkManager()
        sut = FeedPresenter(networkManager: network)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEmpty() {
        let delegate = FeedViewDelegateObject()
        network.result = .success(FeedResponse(data: FeedItems(children: [])))
        sut.setViewDelegate(delegate)

        let expectation = XCTestExpectation(description: "Feed")
        var model: Feed?
        delegate.onUpdateFeed = { m in
            model = m
            expectation.fulfill()
        }

        sut.getNewFeedItems()
        wait(for: [expectation], timeout: 1)

        XCTAssertNotNil(model)
        if let model {
            XCTAssertTrue(model.newFeedItems.isEmpty)
        }
    }

    func testNotEmpty() {
        let delegate = FeedViewDelegateObject()
        let item = FeedItem.mock(isVideo: false)
        network.result = .success(FeedResponse(data: FeedItems(children: [FeedItemData(data: item)])))
        sut.setViewDelegate(delegate)

        let expectation = XCTestExpectation(description: "Feed")
        var model: Feed?
        delegate.onUpdateFeed = { m in
            model = m
            expectation.fulfill()
        }

        sut.getNewFeedItems()
        wait(for: [expectation], timeout: 1)

        XCTAssertNotNil(model)
        if let model {
            XCTAssertEqual(model.newFeedItems, [item])
        }
    }

    func testNotEmpty_VideoItem() {
        let delegate = FeedViewDelegateObject()
        let item = FeedItem.mock(isVideo: true)
        network.result = .success(FeedResponse(data: FeedItems(children: [FeedItemData(data: item)])))
        sut.setViewDelegate(delegate)

        let expectation = XCTestExpectation(description: "Feed")
        var model: Feed?
        delegate.onUpdateFeed = { m in
            model = m
            expectation.fulfill()
        }

        sut.getNewFeedItems()
        wait(for: [expectation], timeout: 1)

        XCTAssertNotNil(model)
        if let model {
            XCTAssertTrue(model.newFeedItems.isEmpty)
        }
    }

    // TODO: write test for several items and one of them is vide item.
    // TODO: write test for next page items fetch (when existing items list is not empty).

    func testFailure() {
        let delegate = FeedViewDelegateObject()
        network.result = .failure(TestError.test)
        sut.setViewDelegate(delegate)

        let expectation = XCTestExpectation(description: "Feed")
        expectation.isInverted = true
        var model: Feed?
        delegate.onUpdateFeed = { m in
            model = m
            expectation.fulfill()
        }

        sut.getNewFeedItems()
        wait(for: [expectation], timeout: 1)

        XCTAssertNil(model)
    }
}

private class MockNetworkManager: NetworkManagerType {
    var result: Result<FeedResponse, Error>?
    func request<D>(target: RedditTarget, completion: @escaping (Result<D, String>) -> Void) where D: Decodable {
        switch result {
        case .success(let response):
            completion(.success(response as! D))
        case .failure(let error):
            completion(.failure(error.localizedDescription))
        case .none:
            completion(.failure(TestError.test.localizedDescription))
        }
    }
}

private class FeedViewDelegateObject: FeedViewDelegate {

    var onUpdateFeed: ((Feed) -> Void)?
    func updateFeed(with model: Feed) {
        onUpdateFeed?(model)
    }

    var onOpenLink: ((String) -> Void)?
    func openLink(_ urlString: String) {
        onOpenLink?(urlString)
    }
}

private extension FeedItem {
    static func mock(isVideo: Bool) -> FeedItem {
        FeedItem(id: UUID().uuidString, title: "Title", author: "author", createdDate: Float(Date().timeIntervalSince1970), commentsNumber: .random(in: 0...100), url: "", isVideo: isVideo, postHint: nil, permalink: "")
    }
}

extension FeedItem: Equatable {
    public static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        lhs.id == rhs.id
    }
}
