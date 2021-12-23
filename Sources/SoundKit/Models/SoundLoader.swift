//
//  SoundLoader.swift
//  
//
//  Created by Ostap on 04.12.2021.
//

import Foundation
import AVKit

enum URLSessionError: Error {
    case unknownError
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension URLSession {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            dataTask(with: url) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                }
                else {
                    continuation.resume(throwing: URLSessionError.unknownError)
                }
            }
            .resume()
        }
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public actor SoundLoader {
    public static let shared = SoundLoader()
    
    private var sounds = [URL: LoadingStatus]()
    
    private enum LoadingStatus {
        case inProgress(Task<Data, Error>)
        case fetched(Data)
    }
    
    private func fileName(for url: URL) -> URL? {
        guard let fileName = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics),
          let applicationSupport = FileManager.default.applicationSupportDirectory else {
            return nil
        }
        
        return applicationSupport.appendingPathComponent(fileName)
    }
    
    private func dataFromFileSystem(for url: URL) -> Data? {
        guard let fileUrl = fileName(for: url) else {
            assertionFailure("Unable to generate a local path for \(url)")
            return nil
        }
        
        return try? Data(contentsOf: fileUrl)
    }
    
    private func persistData(_ data: Data, for url: URL) throws {
        guard let url = fileName(for: url) else {
            assertionFailure("Unable to generate a local path for \(url)")
            return
        }

        try data.write(to: url)
    }

    
    private func player(from task: Task<Data, Error>) async throws -> AVAudioPlayer {
        let data = try await task.value
        return try AVAudioPlayer(data: data)
    }
    
    public func player(for url: URL) async throws -> AVAudioPlayer {
        print("player(for: \(url))")
        
        if let status = sounds[url] {
            switch status {
                case .fetched(let data):
                    print("Using cached data from memory")
                    return try AVAudioPlayer(data: data)
                case .inProgress(let task):
                    return try await player(from: task)
            }
        }
        
        if let data = dataFromFileSystem(for: url) {
            print("Using cached data from disk")
            sounds[url] = .fetched(data)
            return try AVAudioPlayer(data: data)
        }
        
        print("Using the network")
        
        let task: Task<Data, Error> = Task {
            let (data, _) = try await URLSession.shared.data(from: url)
            try persistData(data, for: url)
            return data
        }
        
        sounds[url] = .inProgress(task)
        
        let data = try await task.value
        
        sounds[url] = .fetched(data)
        
        return try AVAudioPlayer(data: data)
    }
    
    public init() {
        
    }
}

