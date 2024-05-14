



export class ColumnModifier implements AttributeModifier<ColumnAttribute>{
  private paddingNumber: Padding = {left:20,right:20};
  private marginNumber: Margin |Length= 0
  private backgroundColors: ResourceColor="rgb(245, 245, 245)"
  applyNormalAttribute(instance: ColumnAttribute): void {
    instance.padding(this.paddingNumber);
    instance.margin(this.marginNumber);
    instance.backgroundColor(this.backgroundColors)
  }
  setPadding(paddingNumber: Padding): ColumnModifier{
    this.paddingNumber=paddingNumber
    return this;
  }
  margin(marginNumber: Margin|Length): ColumnModifier{
    this.marginNumber=marginNumber
    return this;
  }
  backgroundColor(backgroundColors: ResourceColor): ColumnModifier{
    this.backgroundColors=backgroundColors
    return this;
  }
}
export class RowModifier implements AttributeModifier<RowAttribute>{
  private paddingNumber: Padding = {left:20,right:20};
  private marginNumber: Margin |Length= 0
  applyNormalAttribute(instance: RowAttribute): void {
    instance.padding(this.paddingNumber);
    instance.margin(this.marginNumber);
  }
  setPadding(paddingNumber: Padding): RowModifier{
    this.paddingNumber=paddingNumber
    return this;
  }
  margin(marginNumber: Margin|Length): RowModifier{
    this.marginNumber=marginNumber
    return this;
  }
}