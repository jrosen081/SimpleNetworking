import XCTest
import SimpleNetworking

class DataFactoryMock: DataTaskCreatorFactory {
	var mockNetworkRequest: MockNetworkURLRequest!
	func createNetworkURLRequest(urlSessionConfiguration: URLSessionConfiguration, delegate: URLSessionDataDelegate) -> NetworkURLRequest {
		self.mockNetworkRequest = MockNetworkURLRequest(configuration: urlSessionConfiguration, delegate: delegate)
		return self.mockNetworkRequest
	}
}

class MockNetworkURLRequest: NetworkURLRequest {
	let configuration: URLSessionConfiguration
	let delegate: URLSessionDataDelegate
	
	var mockResumable: MockResumable!
	
	init(configuration: URLSessionConfiguration, delegate: URLSessionDataDelegate) {
		self.configuration = configuration
		self.delegate = delegate
	}
	
	func dataTask(request urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Resumable {
		self.mockResumable = MockResumable(completionHandler: completionHandler, urlRequest: urlRequest)
		return self.mockResumable
	}
	
	func finishTasksAndInvalidate() {
		// Finish
	}
}

struct MockResumable: Resumable {
	let completionHandler: (Data?, URLResponse?, Error?) -> Void
	let urlRequest: URLRequest
	
	func resume() {
		// Resume
	}
}

struct MockRequest: NetworkRequest {
	typealias ResponseDataType = String
	
	var urlRequest: URLRequest {
		let url = URL(string: "https://www.google.com")!
		let urlRequest = URLRequest(url: url)
		return urlRequest
	}
}

class NetworkRequestTests: XCTestCase {
    	
	func testUsingCompletion() {
		let factory = DataFactoryMock()
		let loader = NetworkRequestCaller(factory: factory)
		var calls = 0
		loader.makeNetworkRequest(request: MockRequest(), waitsForNetwork: true) { value in
			switch value {
			case .success(let type):
				XCTAssertEqual(type, "My name")
				XCTAssertEqual(calls, 1)
			case .waitForNetwork:
				XCTAssertEqual(calls, 0)
			default:
				break
			}
		}
		if #available(iOS 11.0, *) {
			factory.mockNetworkRequest.delegate.urlSession?(URLSession.shared, taskIsWaitingForConnectivity: URLSessionTask())
		}
		calls += 1
		factory.mockNetworkRequest.mockResumable.completionHandler("My name".data(using: .utf8), URLResponse(), nil)
	}
	
	@available(iOS 13.0, *)
	func testUsingPublisher() {
		let factory = DataFactoryMock()
		let loader = NetworkRequestCaller(factory: factory)
		var calls = 0
		let _ = loader.makeNetworkRequest(request: MockRequest(), waitsForNetwork: true)
			.sink(receiveValue: { value in
			   switch value {
			   case .success(let type):
				   XCTAssertEqual(type, "My name")
				   XCTAssertEqual(calls, 1)
			   case .waitForNetwork:
				   XCTAssertEqual(calls, 0)
			   default:
				   break
			   }
			})
		factory.mockNetworkRequest.delegate.urlSession?(URLSession.shared, taskIsWaitingForConnectivity: URLSessionTask())
		calls += 1
		factory.mockNetworkRequest.mockResumable.completionHandler("My name".data(using: .utf8), URLResponse(), nil)
	}
	
	@available(iOS 13.0, *)
	func testUsingFuture() {
		let factory = DataFactoryMock()
		let loader = NetworkRequestCaller(factory: factory)
		var calls = 0
		let _ = loader.makeNetworkRequest(request: MockRequest())
			.sink(receiveValue: { value in
			   switch value {
			   case .success(let type):
				   XCTAssertEqual(type, "My name")
				   XCTAssertEqual(calls, 1)
			   case .waitForNetwork:
				   XCTAssertEqual(calls, 0)
			   default:
				   break
			   }
			})
		factory.mockNetworkRequest.delegate.urlSession?(URLSession.shared, taskIsWaitingForConnectivity: URLSessionTask())
		calls += 1
		factory.mockNetworkRequest.mockResumable.completionHandler("My name".data(using: .utf8), URLResponse(), nil)
	}
	
	@available(iOS 11, *)
	func testConfiguration() {
		let factory = DataFactoryMock()
		let loader = NetworkRequestCaller(factory: factory)
		loader.makeNetworkRequest(request: MockRequest(), waitsForNetwork: true) { _ in }
		XCTAssertTrue(factory.mockNetworkRequest.configuration.waitsForConnectivity)
		loader.makeNetworkRequest(request: MockRequest(), waitsForNetwork: false) { _ in }
		XCTAssertFalse(factory.mockNetworkRequest.configuration.waitsForConnectivity)

	}
}
