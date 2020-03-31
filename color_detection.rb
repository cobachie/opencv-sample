require 'opencv'
include OpenCV

# 赤、青、緑を検出する
# ref: https://algorithm.joho.info/programming/python/opencv-color-detection/

def detect_red_color(image)
  # HSV色空間に変換
  hsv = OpenCV::BGR2HSV(image)

  # 赤色のHSVの値域1
  hsv_min = OpenCV::CvScalar.new(0,64,0)
  hsv_max = OpenCV::CvScalar.new(30,255,255)
  mask1 = hsv.in_range(hsv_min, hsv_max)

  # 赤色のHSVの値域2
  hsv_min = OpenCV::CvScalar.new(150,64,0)
  hsv_max = OpenCV::CvScalar.new(179,255,255)
  mask2 = hsv.in_range(hsv_min, hsv_max)

  # 赤色領域のマスク
  mask = (mask1 + mask2)

  # マスキング処理
  masked_image = image.and image, mask

  # NOTE:
  # 上記だと bitwise_and が正しく計算されない。
  # 一度 mask 画像を保存して、それを利用して bitwise_and することで意図した結果を得られた。
  # mask.save 'mask.png'
  # mask = OpenCV::IplImage::load 'mask.png'
  # masked_image = image.and mask
end

def detect_green_color(image)
  # HSV色空間に変換
  hsv = OpenCV::BGR2HSV(image)

  # 緑色のHSVの値域1
  hsv_min = OpenCV::CvScalar.new(30, 64, 0)
  hsv_max = OpenCV::CvScalar.new(90,255,255)
  mask = hsv.in_range(hsv_min, hsv_max)

  # マスキング処理
  masked_image = image.and image, mask
end

def detect_blue_color(image)
  # HSV色空間に変換
  hsv = OpenCV::BGR2HSV(image)

  # 青色のHSVの値域1
  hsv_min = OpenCV::CvScalar.new(90, 64, 0)
  hsv_max = OpenCV::CvScalar.new(150,255,255)
  mask = hsv.in_range(hsv_min, hsv_max)

  # マスキング処理
  masked_image = image.and image, mask
end

# 入力画像の読み込み
input_filename = 'images/rgb.png'
image = OpenCV::IplImage::load input_filename, OpenCV::CV_LOAD_IMAGE_COLOR

# 色検出（赤、緑、青）
red_masked_image    = detect_red_color(image)
green_masked_image  = detect_green_color(image)
blue_masked_image   = detect_blue_color(image)


# 結果画像を保存
red_masked_image.save "red_masked_img.png"
green_masked_image.save "green_masked_img.png"
blue_masked_image.save "blue_masked_img.png"
