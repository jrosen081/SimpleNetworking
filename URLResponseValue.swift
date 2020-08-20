//
//  URLResponseValue.swift
//  SimpleNetworking
//
//  Created by Jack Rosen on 8/17/20.
//

import Foundation

/// These are the possible response values from a network request
/// UrlResponseValue.waitForNetwork will only be a valid response if `true` is
/// passed in when asking if the call should wait for network
public enum UrlResponseValue<SuccessResponse> {
	case waitForNetwork
	case success(SuccessResponse)
	case error(Error)
}
