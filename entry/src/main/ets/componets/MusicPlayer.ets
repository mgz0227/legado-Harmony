import { BusinessError } from '@ohos.base';
import media from '@ohos.multimedia.media';
import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';

let avPlayer: media.AVPlayer;
let seekTime: number = 15000

@Component
export struct MusicPlayer {
  @StorageLink('WindowWidth') WindowWidth: number = 0
  @Prop WidthMinus: number = 0
  @State hasInit: boolean = false;
  @State isMusicPlaying: boolean = false; // 音乐播放状态
  @State MusicPlayingTime: number = 0 // 音乐目前播放时间
  @State MusicDuration: number = 100 // 音乐总时长
  @State isShowSpeed: boolean = false;

  // private Player: media.AVPlayer = new media

  // 格式化时间
  formatMilliseconds(milliseconds: number): string {
    const totalSeconds = Math.floor(milliseconds / 1000);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;

    // 格式化秒数为两位数字
    const formattedSeconds = seconds < 10 ? `0${seconds}` : `${seconds}`;

    return `${minutes}:${formattedSeconds}`;
  }

  async aboutToAppear() {
    let audioSelectOptions = new picker.AudioSelectOptions();
    let audioPicker = new picker.AudioViewPicker();

    media.createAVPlayer().then((video: media.AVPlayer) => {
      if (video != null) {
        avPlayer = video;
        console.info('createAVPlayer success');
      } else {
        console.error('createAVPlayer fail');
      }
    }).catch((error: BusinessError) => {
      console.error(`AVPlayer catchCallback, error message:${error.message}`);
    });

    // todo:这里暂时用 picker选本地音乐，音乐的 URL后期需要改成从上级组件传进来
    await audioPicker.select(audioSelectOptions).then((audioSelectResult: Array<string>) => {
      console.info('AudioViewPicker.select successfully, audioSelectResult uri: ' + JSON.stringify(audioSelectResult));
      avPlayer.url = 'fd://' + fs.openSync(audioSelectResult[0]).fd.toString();
    })

    await this.setCallback(avPlayer)
    this.timeDurationUpdateCallback(avPlayer)
  }

  build() {
    Column({ space: 24 }) {
      Row() {
        Stack() {
          Flex() {
            Text(`${this.formatMilliseconds(this.MusicPlayingTime)}/${this.formatMilliseconds(this.MusicDuration)}`)
              .font({
                size: 10,
                weight: 400
              })
          }
          .margin({
            // 需要在模拟器查看
            left: (this.WindowWidth - this.WidthMinus) * this.MusicPlayingTime / this.MusicDuration
          })
          .borderRadius(33)
          .width(70)
          .zIndex(2)
          .backgroundColor('#FFFFFF')
          .padding({
            top: 4,
            bottom: 4,
            left: 8,
            right: 8
          })

          Line().width("100%").height(2).backgroundColor('#FFFFFF')
        }
        .alignContent(Alignment.Start)
        .width("100%")
      }

      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center
      }) {
        Image($r("app.media.Backward"))
          .width(24)
          .onClick(() => {
            avPlayer.seek(this.MusicPlayingTime - seekTime < 0 ? 0 : this.MusicPlayingTime - seekTime,
              media.SeekMode.SEEK_PREV_SYNC)
          })
        Image($r("app.media.Previous"))
          .width(24)
          .onClick(() => {
          })
        Image($r(this.isMusicPlaying ? "app.media.stop" : "app.media.music_play"))
          .fillColor(Color.White)
          .width(80)
          .onClick(async () => {
            if (this.isMusicPlaying) {
              avPlayer.pause()
              avPlayer.off('timeUpdate')
            } else {
              avPlayer.play()
              this.timeUpdateCallback()
            }
          })

        Image($r("app.media.next"))
          .width(24)
          .onClick(() => {
          })
        Image($r("app.media.forward"))
          .width(24)
          .onClick(() => {
            avPlayer.seek(this.MusicPlayingTime + seekTime, media.SeekMode.SEEK_NEXT_SYNC)
          })
      }
      .width("100%")

      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center
      }) {
        Column() {
          Image($r("app.media.appointment_time"))
            .width(24)
            .onClick(() => {
            })
          Text("定时")
        }

        Column() {
          Image($r("app.media.speed"))
            .width(24)
            .onClick(() => {

            })
          Text("语速")
        }.bindSheet($$this.isShowSpeed, this.SpeedDialog(), {
          height: 326,
          showClose: false,
          dragBar: false,
          blurStyle: BlurStyle.COMPONENT_ULTRA_THIN,
        })

        Column() {
          Image($r("app.media.add_bookshelf"))
            .fillColor(Color.White)
            .width(80)
            .onClick(() => {

            })
          Text("加书架")
        }

        Column() {
          Image($r("app.media.directory"))
            .width(24)
            .onClick(() => {
            })
          Text("目录")
        }
      }
      .width("100%")

      Row() {

      }
    }
  }

  setCallback(avPlayer: media.AVPlayer) {
    avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      console.info('reason:' + reason) // reason:1 USER; 2 BACKGROUND;
      switch (state) {
        case 'idle':
          console.info('state idle called');
          break;
        case 'initialized':
          console.info('initialized prepared called')
          this.hasInit = true;
          avPlayer.prepare()
          break;
        case 'playing':
          console.info('audio play success')
          this.isMusicPlaying = true
          break;
        case 'paused':
          console.info('audio paused success')
          this.isMusicPlaying = false
          break;
        case 'error':
          console.error('state error called');
          break;
        default:
          console.info('unkown state :' + state);
          break;
      }
    })
  }

  // 用于获取音频目前播放时间
  timeUpdateCallback() {
    avPlayer.on('timeUpdate', (time: number) => {
      console.info('timeUpdate success,and new time is :' + time)
      this.MusicPlayingTime = time
    })
  }

  // 用于获取音频的总时间长度
  timeDurationUpdateCallback(avPlayer: media.AVPlayer) {
    avPlayer.on('durationUpdate', (duration: number) => {
      console.info('durationUpdate success,new duration is :' + duration)
      this.MusicDuration = duration
    })
  }

  @Builder
  SpeedDialog() {
    Column() {
      Row() {
        Text("语速设置")
        Blank(1)
        Text("仅用于当前")
        Toggle({ type: ToggleType.Switch, isOn: false })
      }

      Row() {

      }
    }
  }
}