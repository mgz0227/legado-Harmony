/**
 * @author 2008
 * @datetime 2024/5/27 0:09
 * @className: photoViewPicker
 * 图片选择工具
 */
import picker from '@ohos.file.picker';


 export const pickerAvatar = async () => {
  // 实例化选项对象
  const options = new picker.PhotoSelectOptions()
  // 过滤选择媒体文件类型为IMAGE——只能选择图片类型的资源
  options.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
  // 只能选择一张系统相册中的照片
  options.maxSelectNumber = 1

  // 利用PhotoViewPicker对象实例中的select自动获取到用户选择的那张图片的地址
  const pickerView = new picker.PhotoViewPicker()
  let urls = await pickerView.select(options)
  if (urls.photoUris.length <= 0) {
    return
  }
  return urls
}


