//
//  StorageManager.swift
//  AppChat
//
//  Created by Vu Minh Tam on 7/20/21.
//


import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    /*
     /images/afraz9-gmail-com_profile_picture.png
     */
    
    
    // Uploads picture to firebase storage and returns completion with url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, success: @escaping(String) -> Void, failured: @escaping(Error) -> Void) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                // failed
                print("Failed to upload data to firebase for picture")
                failured(StorageErrors.failedToUpload)
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    failured(StorageErrors.failedToGetBownloadUrl)
                    return
                }
                
                let urlString = url.absoluteString
                print("download url returned:\(urlString)")
                success(urlString)
            })
            
        })
    }
    
    // Uploads image that will be sent in a conversation message
    public func uploadMessagePhoto(with data: Data, fileName: String, success: @escaping(String) -> Void, failured: @escaping(Error) -> Void) {
        storage.child("message_images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
                // failed
                print("Failed to upload data to firebase for picture")
                failured(StorageErrors.failedToUpload)
                return
            }
            
            self?.storage.child("message_images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    failured(StorageErrors.failedToGetBownloadUrl)
                    return
                }
                
                let urlString = url.absoluteString
                print("download url returned:\(urlString)")
                success(urlString)
            })
            
        })
    }
    
    // Uploads video that will be sent in a conversation message
    public func uploadMessageVideo(with fileUrl: URL, fileName: String, success: @escaping(String) -> Void, failured: @escaping(Error) -> Void) {
        storage.child("message_videos/\(fileName)").putFile(from: fileUrl, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
                // failed
                print("Failed to upload video to firebase for picture")
                failured(StorageErrors.failedToUpload)
                return
            }
            
            self?.storage.child("message_videos/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    failured(StorageErrors.failedToGetBownloadUrl)
                    return
                }
                
                let urlString = url.absoluteString
                print("download url returned:\(urlString)")
                success(urlString)
            })
            
        })
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetBownloadUrl
    }
    
    public func downloadURL(for path: String, completion: @escaping(Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        
        reference.downloadURL(completion: {url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetBownloadUrl))
                return
            }
            completion(.success(url))
        })
    }
    
}

