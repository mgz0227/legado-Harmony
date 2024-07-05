interface ScoreStyle {
  img: string
  text: string
  textColor: ResourceColor
  scoreColor: ResourceColor,
  background: ResourceColor
}

const SCORE_STYLE: Record<number, ScoreStyle> = {
  0: {
    img: 'rectangle_1',
    text: '常规',
    textColor: '#ffffff',
    scoreColor: '#ffffff',
    background: '#D8ECFF'
  },
  4: {
    img: 'rectangle_5',
    text: '优质',
    textColor: '#ffffff',
    scoreColor: '#C07000',
    background: '#FFDDAD'
  },
  5: {
    img: 'rectangle_5',
    text: '优质',
    textColor: '#ffffff',
    scoreColor: '#C07000',
    background: '#FFDDAD'
  },
  99: {
    img: 'rectangle_icon',
    text: '精品',
    textColor: '#FFE5D4',
    scoreColor: '#854D00',
    background: '#FFE5D4'
  }
}

@Component
export default struct Score {
  @Prop score: number = 0
  @Prop isBoutique: boolean = false

  build() {
    Row() {
      Row() {
        Stack() {
          Image($r(`app.media.${SCORE_STYLE[this.isBoutique?99:this.score]?.img ?? SCORE_STYLE[0].img}`))
            .borderRadius({
              topLeft: 4,
              bottomLeft: 4
            })
            .width(28)
            .height(16)

          Text(SCORE_STYLE[this.isBoutique?99:this.score]?.text ?? SCORE_STYLE[0].text)
            .fontSize(9)
            .fontColor(SCORE_STYLE[this.isBoutique?99:this.score]?.textColor ?? SCORE_STYLE[0].textColor)
        }

        Text(this.score.toFixed(1))
          .padding({left: 1})
          .fontSize(11)
          .fontWeight(400)
          .lineHeight(12)
          .fontColor(SCORE_STYLE[this.isBoutique?99:this.score]?.scoreColor ?? SCORE_STYLE[0].scoreColor)
      }
      .width(47)
      .height(16)
      .borderRadius(4)
      .backgroundColor(SCORE_STYLE[this.isBoutique?99:this.score]?.background ?? SCORE_STYLE[0].background)

      Rating({ rating: this.score, indicator: true })
        .size({
          width: 90,
          height: 20
        })
        .stars(5)
        .stepSize(0.5)
        .margin({ left: 8 })
    }
  }
}