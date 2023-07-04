//
//  Inbox Reply View.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-25.
//

import SwiftUI

// /user/replies

struct InboxReplyView: View {
    let spacing: CGFloat = 10
    let userAvatarWidth: CGFloat = 30
    
    let account: SavedAccount
    let reply: APICommentReplyView
    let menuFunctions: [MenuFunction]
    
    let publishedAgo: String
    let voteIconName: String
    let voteColor: Color
    
    var iconName: String { reply.commentReply.read ? "arrowshape.turn.up.right" : "arrowshape.turn.up.right.fill" }
    
    init(account: SavedAccount, reply: APICommentReplyView, menuFunctions: [MenuFunction]) {
        self.account = account
        self.reply = reply
        self.menuFunctions = menuFunctions
        
        switch reply.myVote {
        case .upvote:
            voteIconName = "arrow.up"
            voteColor = .upvoteColor
        case .downvote:
            voteIconName = "arrow.down"
            voteColor = .downvoteColor
        default:
            voteIconName = "arrow.up"
            voteColor = .secondary
        }
        
        self.publishedAgo = getTimeIntervalFromNow(date: reply.commentReply.published)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text(reply.post.name)
                .font(.headline)
                .padding(.bottom, spacing)
            
            UserProfileLink(user: reply.creator, showServerInstance: true)
                .font(.subheadline)
            
            HStack(alignment: .top, spacing: spacing) {
                Image(systemName: iconName)
                    .foregroundColor(.accentColor)
                    .frame(width: userAvatarWidth)
                
                MarkdownView(text: reply.comment.content, isNsfw: false)
                    .font(.subheadline)
            }
            
            CommunityLinkView(community: reply.community)
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: voteIconName)
                    Text(reply.counts.score.description)
                }
                .foregroundColor(voteColor)
                
                EllipsisMenu(size: userAvatarWidth, menuFunctions: menuFunctions)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text(publishedAgo)
                }
                .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}