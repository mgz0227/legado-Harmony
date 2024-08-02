import measure from '@ohos.measure'
import I18n from '@ohos.i18n';

// 小说内容解析辅助工具
export class NovelContentParseHelper {
  /**
   * 根据给定的页面大小对章节内容进行分页计算
   * Paginate the chapter content according to the given page size.
   *
   * @param {string[]} paragraphList 章节的段落列表 the list of paragraph in the chapter
   * @param {number} fontSize 展示内容的文字大小 the text size of display config
   * @param {number} lineHeight 展示内容的行高 the line height of display config
   * @param {number} measureContentWidth 展示区域的宽度 the width of display area
   * @param {number} measureContentHeight 展示区域的高度 the height of display area
   * @return {Promise<string>} 章节中每页的内容列表 The list of content for each page in chapter
   */
  static async calculateChapterContent(paragraphList: string[], fontSize: number, lineHeight: number,
    measureContentWidth: number, measureContentHeight: number): Promise<string[][]> {
    let tempParagraphList = paragraphList.slice()
    let wordSize = measure.measureTextSize({
      textContent: '测', // 随便找的测试文字，用来测试一个字有多大。
      fontSize: fontSize,
      lineHeight: lineHeight
    });
    let pageIndex = 0;
    let pageContent: string[][] = [];
    while (tempParagraphList.length != 0) {
      try {
        let pageParagraphList =
          await NovelContentParseHelper.calculateParagraphForPage(tempParagraphList, measureContentHeight,
            measureContentWidth, wordSize, fontSize, lineHeight)

        pageContent[pageIndex] = pageParagraphList
        pageIndex++;
      } catch (e) {
        console.error(e)
      }
    }

    return pageContent
  }

  /**
   * 根据给定的段落，计算一页的内容
   * 会自动移除已经计算过的段落
   * Calculate the content of each page line by line
   *
   * @param {string[]} paragraphs 目标段落列表 the target paragraph list
   * @param {number} targetHeight 展示内容的文字大小 the text size of display config
   * @param {number} targetWidth 展示内容的行高 the line height of display config
   * @param {SizeOptions} wordSize 展示区域的宽度 the width of display area
   * @param {number} fontSize 展示内容的文字大小 the text size of display config
   * @param {number} lineHeight 展示内容的行高 the line height of display config
   * @return {Promise<string>} 每页的段落列表 The list of content for each page in chapter
   */
  static calculateParagraphForPage(paragraphs: string[], targetHeight: number, targetWidth: number,
    wordSize: SizeOptions, fontSize: number, lineHeight: number,): Promise<string[]> {
    return new Promise((resolve, reject) => {
      let constraintWidth = targetWidth;

      let wordWidth: number = typeof wordSize.width === 'number' ? (wordSize.width ?? 0) : 0
      let wordHeight: number = typeof wordSize.height === 'number' ? (wordSize.height ?? 0) : 0

      let guessLineWordCount = Math.floor(constraintWidth / wordWidth)
      let maxLines = Math.floor(targetHeight / wordHeight);

      // 断句对象
      let breakIterator = I18n.getLineInstance('cn');

      let result: string[] = [];

      let currentLineIndex = 0;

      const lineFeed = '\n';

      while (currentLineIndex < maxLines && paragraphs.length != 0) {
        let currentTarget = paragraphs[0]
        let isNeedAddLineFeed = currentTarget.endsWith(lineFeed);
        if (isNeedAddLineFeed) {
          currentTarget = currentTarget.substring(0, currentTarget.length - 1)
        }
        if (currentTarget.length < guessLineWordCount) {
          result[currentLineIndex] = currentTarget + (isNeedAddLineFeed ? lineFeed : '');
          currentLineIndex++
          paragraphs.splice(0, 1)
        } else {

          let tempCurrentTarget = currentTarget;

          let lineCount = (NovelContentParseHelper.measureTextHeight(tempCurrentTarget, constraintWidth, fontSize,
            lineHeight) / wordHeight);

          if (lineCount == 1) {
            result[currentLineIndex] = tempCurrentTarget + (isNeedAddLineFeed ? lineFeed : '');
            currentLineIndex++
            paragraphs.splice(0, 1)
          } else {
            breakIterator.setLineBreakText(currentTarget)
            breakIterator.following(guessLineWordCount)
            breakIterator.previous();
            tempCurrentTarget = currentTarget.substring(0, breakIterator.current())
            lineCount =
              NovelContentParseHelper.measureTextHeight(tempCurrentTarget, constraintWidth, fontSize, lineHeight) /
                wordHeight;

            if (lineCount > 1) {
              while (lineCount > 1) {
                tempCurrentTarget = currentTarget.substring(0, breakIterator.previous())
                lineCount =
                  NovelContentParseHelper.measureTextHeight(tempCurrentTarget, constraintWidth, fontSize, lineHeight) /
                    wordHeight;
              }
              result[currentLineIndex] = tempCurrentTarget;
              currentLineIndex++
              paragraphs[0] = paragraphs[0].substring(tempCurrentTarget.length, paragraphs[0].length)
            } else {
              while (lineCount <= 1) {
                tempCurrentTarget = currentTarget.substring(0, breakIterator.next())
                lineCount =
                  NovelContentParseHelper.measureTextHeight(tempCurrentTarget, constraintWidth, fontSize, lineHeight) /
                    wordHeight;
              }
              tempCurrentTarget = currentTarget.substring(0, breakIterator.previous())
              result[currentLineIndex] = tempCurrentTarget
              currentLineIndex++
              paragraphs[0] = paragraphs[0].substring(tempCurrentTarget.length, paragraphs[0].length)
            }
          }
        }
      }

      resolve(result)
    });
  }

  /**
   * 测量给定文字的高度
   * measure the height of text
   *
   * @param {string} content 文字内容 the content of given text
   * @param {number} constraintWidth 约束宽度 the measure width;
   * @param {number} fontSize 展示内容的文字大小 the text size of display config
   * @param {number} lineHeight 展示内容的行高 the line height of display config
   * @return {number} 测量的文字高度 The height of given text
   */
  static measureTextHeight(content: string, constraintWidth: number, fontSize: number, lineHeight: number): number {
    let height = measure.measureTextSize({
      textContent: content,
      constraintWidth: `${constraintWidth}px`,
      fontSize: fontSize,
      lineHeight: lineHeight
    }).height

    return typeof height === 'number' ? height : 0;
  }
}