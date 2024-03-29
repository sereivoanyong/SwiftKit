//
//  URLSession.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

import Foundation

extension URLSession {

  @inlinable
  public func dataTask(with request: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), URLError>) -> Void) -> URLSessionDataTask {
    dataTask(with: request) { data, response, error in
      if let error {
        completion(.failure(error as! URLError))
      } else {
        completion(.success((data!, response as! HTTPURLResponse)))
      }
    }
  }

  @inlinable
  public func uploadTask(with request: URLRequest, fromFile fileURL: URL, completion: @escaping (Result<(Data, HTTPURLResponse), URLError>) -> Void) -> URLSessionUploadTask {
    uploadTask(with: request, fromFile: fileURL) { data, response, error in
      if let error {
        completion(.failure(error as! URLError))
      } else {
        completion(.success((data!, response as! HTTPURLResponse)))
      }
    }
  }

  @inlinable
  public func uploadTask(with request: URLRequest, from bodyData: Data?, completion: @escaping (Result<(Data, HTTPURLResponse), URLError>) -> Void) -> URLSessionUploadTask {
    uploadTask(with: request, from: bodyData) { data, response, error in
      if let error {
        completion(.failure(error as! URLError))
      } else {
        completion(.success((data!, response as! HTTPURLResponse)))
      }
    }
  }

  @inlinable
  public func downloadTask(with request: URLRequest, completion: @escaping (Result<(URL, HTTPURLResponse), URLError>) -> Void) -> URLSessionDownloadTask {
    downloadTask(with: request) { url, response, error in
      if let error {
        completion(.failure(error as! URLError))
      } else {
        completion(.success((url!, response as! HTTPURLResponse)))
      }
    }
  }

  @inlinable
  public func downloadTask(withResumeData resumeData: Data, completion: @escaping (Result<(URL, HTTPURLResponse), URLError>) -> Void) -> URLSessionDownloadTask {
    downloadTask(withResumeData: resumeData) { url, response, error in
      if let error {
        completion(.failure(error as! URLError))
      } else {
        completion(.success((url!, response as! HTTPURLResponse)))
      }
    }
  }
}
