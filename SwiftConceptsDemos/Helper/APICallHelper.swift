//
//  APICallHelper.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 08/03/24.
//

import SwiftUI

class WebService {
    func downloadData<T: Codable>(fromURL: String, header: [String:String]?,body: Data?) async -> T? {
        do {
            guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
            var urlReq = URLRequest(url: url)
            if let body {
                urlReq.httpBody = body
            }
            if let header {
                urlReq.allHTTPHeaderFields = header
            }
            let (data, response) = try await URLSession.shared.data(for: urlReq)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.failedToDecodeResponse }
            
            return decodedResponse
        } catch NetworkError.badUrl {
            print("There was an error creating the URL")
        } catch NetworkError.badResponse {
            print("Did not get a valid response")
        } catch NetworkError.badStatus {
            print("Did not get a 2xx status code from the response")
        } catch NetworkError.failedToDecodeResponse {
            print("Failed to decode response into the given type")
        } catch {
            print("An error occured downloading the data")
        }
        
        return nil
    }
}
