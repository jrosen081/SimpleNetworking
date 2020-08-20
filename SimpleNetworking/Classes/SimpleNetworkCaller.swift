import Foundation

public protocol SimpleNetworkCaller {
	/// Performs a network request with request, calling the response value when necessary
	/// - parameters:
	///		- request: The network request to perform. This gives data about the url request, and the response type
	///     - waitsForNetwork: Should the request retry when the network comes back. If this is set to `true`, completion will be called more than once, with all tries before the last returning `UrlResponseValue.waitForNetwork`
	/// 	- completion: The completion handler that is called when the request resolves
	func makeNetworkRequest<Request: NetworkRequest>(request: Request, waitsForNetwork: Bool, completion: @escaping (UrlResponseValue<Request.ResponseDataType>) -> ())
}
