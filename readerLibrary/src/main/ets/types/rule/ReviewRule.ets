/**
 * 段评规则
 */
export class ReviewRule {
  reviewUrl?: string          // 段评URL
  avatarRule?: string         // 段评发布者头像
  contentRule?: string        // 段评内容
  postTimeRule?: string       // 段评发布时间
  reviewQuoteUrl?: string     // 获取段评回复URL

  // 这些功能将在以上功能完成以后实现
  voteUpUrl?: string          // 点赞URL
  voteDownUrl?: string        // 点踩URL
  postReviewUrl?: string      // 发送回复URL
  postQuoteUrl?: string       // 发送回复段评URL
  deleteUrl?: string          // 删除段评URL
}