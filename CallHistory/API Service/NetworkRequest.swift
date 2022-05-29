//
//  NetworkRequest.swift
//  CallHistory
//
//  Created by Viacheslav Yakymenko on 04.05.2022.
//

import Foundation

class NetworkRequest {
    
    static let shared = NetworkRequest()
    
    func loadCalls(url: String, completion: @escaping ( Result<[Request], Error> ) -> Void) {
        guard let requestUrl = URL(string: url) else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            guard let response = response as? HTTPURLResponse,
                  let data = data,
                  error == nil else {
                      completion(.failure(error ?? NetworkError.unknown))
                      return
            }
            
            if response.statusCode != 200 {
                completion(.failure(NetworkError.response(response.statusCode) ))
            }
            
            do {
                let parsedData = try JSONDecoder().decode(CallList.self, from: data)
                completion(.success(parsedData.requests))
            } catch {
                completion(.failure(error))
            }
            return
        }
        task.resume()
    }

}
