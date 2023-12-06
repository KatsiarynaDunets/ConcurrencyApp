//
//  Models.swift
//  ConcurrencyApp
//
//  Created by Kate on 06/12/2023.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String?
    let username: String?
    let email: String?
    let phone: String?
    let website: String?
    let address: Address?
    let company: Company?
}

// MARK: - Address

struct Address: Codable {
    let street: String?
    let suite: String?
    let city: String?
    let zipcode: String?
    let geo: Geo?
}

// MARK: - Company

struct Company: Codable {
    let name: String?
    let catchPhrase: String?
    let bs: String?
}

// MARK: - Geo

struct Geo: Codable {
    let lat: String?
    let lng: String?
}

// MARK: - Post

struct Post: Decodable {
    let userId: Int?
    let id: Int?
    let title: String?
    let body: String?
}

// MARK: - Comment

struct Comment: Decodable {
    let postId: Int?
    let id: Int?
    let name: String?
    let email: String?
    let body: String?
}

// MARK: - Album

struct Album: Decodable {
    let userId: Int?
    let id: Int?
    let title: String?
}

// MARK: - Photo

struct Photo: Decodable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

