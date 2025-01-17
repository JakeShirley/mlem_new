//
//  Post Model.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-08-26.
//

import Foundation

/// Internal model to represent a post
/// Note: this is just the first pass at decoupling the internal models from the API models--to avoid massive merge conflicts and an unreviewably large PR, I've kept the structure practically identical, and will slowly morph it over the course of several PRs. Eventually all of the API types that this model uses will go away and everything downstream of the repositories won't ever know there's an API at all :)
struct PostModel {
    let postId: Int
    let post: APIPost
    let creator: UserModel
    let community: CommunityModel
    var votes: VotesModel
    let commentCount: Int
    let unreadCommentCount: Int
    let saved: Bool
    let read: Bool
    let published: Date
    let updated: Date?
    let links: [LinkType]
    
    var uid: ContentModelIdentifier { .init(contentType: .post, contentId: postId) }
    
    /// Creates a PostModel from an APIPostView
    /// - Parameter apiPostView: APIPostView to create a PostModel representation of
    init(from apiPostView: APIPostView) {
        self.postId = apiPostView.post.id
        self.post = apiPostView.post
        self.creator = UserModel(from: apiPostView.creator)
        self.community = CommunityModel(from: apiPostView.community, subscribed: apiPostView.subscribed.isSubscribed)
        self.votes = VotesModel(from: apiPostView.counts, myVote: apiPostView.myVote)
        self.commentCount = apiPostView.counts.comments
        self.unreadCommentCount = apiPostView.unreadComments
        self.saved = apiPostView.saved
        self.read = apiPostView.read
        self.published = apiPostView.post.published
        self.updated = apiPostView.post.updated
        
        self.links = PostModel.parseLinks(from: post.body)
    }
    
    /// Creates a PostModel from another PostModel. Any provided field values will override values in post.
    /// - Parameters:
    ///   - other: PostModel to copy
    ///   - postId: overriden post id
    ///   - post: overriden post content
    ///   - creator: overriden post creator
    ///   - community: overriden post community
    ///   - votes: overriden votes
    ///   - numReplies: overriden number of replies
    ///   - saved: overriden saved status
    ///   - read: overriden read status
    ///   - published: overriden published time
    init(
        from other: PostModel,
        postId: Int? = nil,
        post: APIPost? = nil,
        creator: UserModel? = nil,
        community: CommunityModel? = nil,
        votes: VotesModel? = nil,
        commentCount: Int? = nil,
        unreadCommentCount: Int? = nil,
        saved: Bool? = nil,
        read: Bool? = nil,
        published: Date? = nil,
        updated: Date? = nil
    ) {
        self.postId = postId ?? other.postId
        self.post = post ?? other.post
        self.creator = creator ?? other.creator
        self.community = community ?? other.community
        self.votes = votes ?? other.votes
        self.commentCount = commentCount ?? other.commentCount
        self.unreadCommentCount = unreadCommentCount ?? other.unreadCommentCount
        self.saved = saved ?? other.saved
        self.read = read ?? other.read
        self.published = published ?? other.published
        self.updated = updated ?? other.updated
        
        self.links = PostModel.parseLinks(from: self.post.body)
    }
    
    var postType: PostType {
        // post with URL: either image or link
        if let postUrl = post.linkUrl {
            // if image, return image link, otherwise return thumbnail
            return postUrl.isImage ? .image(postUrl) : .link(post.thumbnailImageUrl)
        }

        // otherwise text, but post.body needs to be present, even if it's an empty string
        if let postBody = post.body {
            return .text(postBody)
        }

        return .titleOnly
    }
    
    static func parseLinks(from body: String?) -> [LinkType] {
        guard let body else {
            return []
        }
        return body.parseLinks()
    }
}

extension PostModel: Identifiable {
    var id: Int { hashValue }
}

extension PostModel: Hashable {
    /// Hashes all fields for which state changes should trigger view updates.
    func hash(into hasher: inout Hasher) {
        hasher.combine(post.id)
        hasher.combine(votes)
        hasher.combine(saved)
        hasher.combine(read)
        hasher.combine(post.updated)
    }
}
