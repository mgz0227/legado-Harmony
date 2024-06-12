import { BusinessError } from '@ohos.base';
import media from '@ohos.multimedia.media';
import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';

let avPlayer: media.AVPlayer;

@Component
export struct MusicPlayer {
  @StorageLink('WindowWidth') WindowWidth: number = 0
  @Prop RightMinus: number = 0
  @State hasInit: boolean = false;
  @State SelectUrl: string = '';
  @State isMusicPlaying: boolean = false;

  // private Player: media.AVPlayer = new media

  async aboutToAppear() {
    // todo:这里暂时用 picker选本地音乐，音乐的 URL后期需要改成从上级组件传进来
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

    await audioPicker.select(audioSelectOptions).then((audioSelectResult: Array<string>) => {
      console.info('AudioViewPicker.select successfully, audioSelectResult uri: ' + JSON.stringify(audioSelectResult));
      let file = fs.openSync(audioSelectResult[0]); //此处用picker返回的uri
      this.SelectUrl = 'fd://' + file.fd.toString();
    })
  }

  build() {
    Column({ space: 24 }) {
      Row() {
        Stack() {
          Flex() {
            Text("02:10/08:35")
              .font({
                size: 10,
                weight: 400
              })
          }
          .margin({
            // 需要在模拟器查看
            left: this.WindowWidth - this.RightMinus
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
              this.isMusicPlaying = false
            } else {
              if (this.hasInit) {
                console.info("Play Again")
                avPlayer.play()
                this.isMusicPlaying = true
              } else {
                this.setCallback(avPlayer)
                avPlayer.url = this.SelectUrl
              }
            }
          })

        Image($r("app.media.next"))
          .width(24)
          .onClick(() => {
          })
        Image($r("app.media.forward"))
          .width(24)
          .onClick(() => {
          })
      }
      .width("100%")

      Row() {

      }

      Row() {

      }
    }
  }

  setCallback(avPlayer: media.AVPlayer) {
    avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      console.info('state:' + state)
      switch (state) {
        case 'idle':
          console.info('state idle called');
          break;
        case 'initialized':
          console.info('initialized prepared called')
          this.hasInit = true;
          avPlayer.prepare().then(() => {
            avPlayer.play()
          })
          break;
        case 'playing':
          console.info('audio play success')
          this.isMusicPlaying = true
          break;
        case 'paused':
          console.info('audio paused success')
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
}