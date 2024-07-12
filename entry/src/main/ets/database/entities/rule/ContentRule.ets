/**
 * 正文处理规则
 */
export class ContentRule {
  content?: string
  title?: string //有些网站只能在正文中获取标题
  nextContentUrl?: string
  webJs?: string
  sourceRegex?: string
  replaceRegex?: string //替换规则
  imageStyle?: string //默认大小居中,FULL最大宽度
  imageDecode?: string //图片bytes二次解密js, 返回解密后的bytes
  payAction?: string //购买操作,js或者包含{{js}}的url
}