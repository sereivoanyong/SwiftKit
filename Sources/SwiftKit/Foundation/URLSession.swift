//
//  URLSession.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(Foundation)
import Foundation

extension URLSession {
  
  @inlinable final public func dataTask(with request: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), URLError>) -> Void) -> URLSessionDataTask {
    return dataTask(with: request) { data, response, error in
      if let error = error {
        completion(.failure(error as! URLError))
      } else {
        completion(.success((data!, response as! HTTPURLResponse)))
      }
    }
  }
  
  @inlinable final public func uploadTask(with request: URLRequest, fromFile fileURL: URL, completion: @escaping (Result<(Data, HTTPURLResponse), URLError>) -> Void) -> URLSessionUploadTask {
    return uploadTask(with: request, fromFile: fileURL) { data, response, error in
      if let error = error {
        completion(.failure(error as! URLError))
      } else {
        completion(.success((data!, response as! HTTPURLResponse)))
      }
    }
  }
  
  @inlinable final public func uploadTask(with request: URLRequest, from bodyData: Data?, completion: @escaping (Result<(Data, HTTPURLResponse), URLError>) -> Void) -> URLSessionUploadTask {
    return uploadTask(with: request, from: bodyData) { data, response, error in
      if let error = error {
        completion(.failure(error as! URLError))
      } else {
        completion(.success((data!, response as! HTTPURLResponse)))
      }
    }
  }
  
  @inlinable final public func downloadTask(with request: URLRequest, completion: @escaping (Result<(URL, HTTPURLResponse), URLError>) -> Void) -> URLSessionDownloadTask {
    return downloadTask(with: request) { url, response, error in
      if let error = error {
        completion(.failure(error as! URLError))
      } else {
        completion(.success((url!, response as! HTTPURLResponse)))
      }
    }
  }
  
  @inlinable final public func downloadTask(withResumeData resumeData: Data, completion: @escaping (Result<(URL, HTTPURLResponse), URLError>) -> Void) -> URLSessionDownloadTask {
    return downloadTask(withResumeData: resumeData) { url, response, error in
      if let error = error {
        completion(.failure(error as! URLError))
      } else {
        completion(.success((url!, response as! HTTPURLResponse)))
      }
    }
  }
}
#endif
