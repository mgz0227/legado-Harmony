import batteryInfo from '@ohos.batteryInfo';


// 表示当前设备剩余电池电量百分比。
let batterySOCInfo: number = batteryInfo.batterySOC;

// 表示当前设备电池的充电状态。
let chargingStatusInfo = batteryInfo.chargingStatus;

@Component
export default struct battery {
  build() {
    Flex() {
      Stack() {
        Flex()
          .height(7)
          .width(20)
          .backgroundColor("red")
          .zIndex(2)
          .borderRadius(1.5)
          .margin({
            left: 2
          })

        Image($r("app.media.Union")).width(26)
      }
      .alignContent(Alignment.Start)

      Image($r("app.media.Vector"))
        .height(12)
        .margin({
          left: 3
        })
        .opacity(0.88)
    }
    .width(38)
  }
}