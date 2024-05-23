import { PublicConstants, TextConstants } from '../constants/PublicConstants';

//column统一样式类
export class ColumnModifier implements AttributeModifier<ColumnAttribute> {
  private paddingNumber: Padding = { left: 20, right: 20 };
  private marginNumber: Margin | Length = 0
  private topRectHeight = AppStorage.get("topRectHeight") as number
  private bottomRectHeight = AppStorage.get("bottomRectHeight") as number
  private backgroundColors: ResourceColor = PublicConstants.WINDOW_BACKGROUND_COLOR

  applyNormalAttribute(instance: ColumnAttribute): void {
    this.paddingNumber.top = this.topRectHeight
    this.paddingNumber.bottom = this.bottomRectHeight
    instance.padding(this.paddingNumber);
    instance.margin(this.marginNumber);
    instance.backgroundColor(this.backgroundColors)
  }

  setCustom(Padding: Padding): ColumnModifier {
    this.paddingNumber = Padding
    this.topRectHeight = 0
    this.bottomRectHeight = 0
    return this;
  }

  setPadding(left: number, right: number): ColumnModifier {
    this.paddingNumber.left = left
    this.paddingNumber.right = right
    return this;
  }

  margin(marginNumber: Margin | Length): ColumnModifier {
    this.marginNumber = marginNumber
    return this;
  }

  backgroundColor(backgroundColors: ResourceColor): ColumnModifier {
    this.backgroundColors = backgroundColors
    return this;
  }
}

//Text统一样式类
export class TextModifier implements AttributeModifier<TextAttribute> {
  private publicFontSize: number | string | Resource = TextConstants.TEXT_FONT_SIZE;
  private publicLineHeight: number | string | Resource = TextConstants.TEXT_LINE_HEIGHT;

  applyNormalAttribute(instance: TextAttribute): void {
    instance.fontSize(this.publicFontSize);
    instance.lineHeight(this.publicLineHeight);
  }

  fontSize(fontSize: number | string | Resource, textType: number = 0) {
    this.publicFontSize = textType == 1 ? TextConstants.TEXT_FONT_SIZE : fontSize
    return this
  }

  lineHeight(lineHeight: number | string | Resource, textType: number = 0) {
    this.publicLineHeight = textType == 1 ? TextConstants.TEXT_LINE_HEIGHT : lineHeight
    return this
  }
}
