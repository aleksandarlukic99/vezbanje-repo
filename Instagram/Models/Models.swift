//
//  Models.swift
//  Instagram
//
//  Created by aleksandar on 18.12.21..
//

import Foundation

public enum UserPostType: String {
    case photo = "Photo"
    case video = "Video"
}

enum Gender {
    case male, female, other
}

struct User {
    let username: String
    let name: (first: String, last: String)
    let bio: String
    let birthDate: Date
    let profilePicture: URL
    let gender: Gender
    let counts: UserCounts
    let joinDate: Date
}

struct UserCounts {
    let followers: Int
    let following: Int
    let posts: Int
}

///Represents a user post
public struct UserPost {
    let identifier: String
    let postType: UserPostType
    let thumbnailImage: URL
    let postURL: URL //either video url or full resolution video
    let caption: String?
    let likeCount: [PostLike]
    let comments: [PostComment]
    let createdDate: Date
    let taggedUsers: [String]
    let owner: User
}

struct PostLike {
    let username: String
    let postIdentifier: String
}

struct CommentLike {
    let username: String
    let commentIdentifier: String
}

struct PostComment {
    let identifier: String
    let username: String
    let text: String
    let createdDate: Date
    let likes: [CommentLike]
}
