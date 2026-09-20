# CAN FD 4ch HAT for Raspberry Pi
MCP2518 + MCP2562FD CAN FD 4ch HAT for Raspberry Pi

### 特徴
- Microchip社のMCP2518とMCP2562FDを使い、必要なコンデンサ、水晶振動子をセットにした4chのCAN FD HATです。
- SPI IFを使ってCANの送受信ができます。
- MCP2518の駆動電圧を3.3V(Rasperry Pi, ESP32向け)としております。
- 終端抵抗のあるなしをジャンパスイッチにて切り替えできます。
- MCP2518向けのドライバにて簡単に利用できます。
- (おまけ)3.3V駆動のESP32でも使うことはできます。

### 「CANape Kernel」活用事例における構成例

ベクター・ジャパン株式会社が開催した「Vector Measurement and Calibration Seminar 2026」のセッション「Linux対応バリアント『CANape Kernel』活用事例」では、「CANape Kernel」を活用したLinux環境の計測・開発事例が紹介され、そのハードウェア構成の一例として、Raspberry PiにCAN FD 4ch HAT for Raspberry Piを接続し、CAN/CAN FDインターフェースとして使用されました。

CANape Kernelの対応ハードウェアやプロトコルについては、[Vector公式のCANape Kernel紹介ページ](https://www.vector.com/en/product/canape-kernel/)を参照してください。

※本記載は、上記セッションにおいて本製品が構成機器の一例として使用された事実を示すものです。本製品について、ベクター・ジャパン株式会社による動作保証、推奨、または認定を示すものではありません。

### 基板
![TopImage](/docs/CAN-FD_4ch_HAT_Top_Image.png)
![BottomImage](/docs/CAN-FD_4ch_HAT_Bottom_Image.png)
![TopPhoto](/docs/CAN-FD_4ch_HAT_Top_Photo.png)
![TopPhoto](/docs/CAN-FD_4ch_HAT_Top_Photo_02.jpg)
![TopPhoto](/docs/CAN-FD_4ch_HAT_Top_Photo_03.jpg)

### 基板の設定
![TopPhoto](/docs/CAN-FD_4ch_HAT_Top_Image_explanation.jpg)

### 使用例
![UseCase_01](/docs/UseCase_01.jpg)

### 販売ページ

- [スイッチサイエンス様](https://ssci.to/10018)

### 資料
- [サポートページ](https://github.com/TLDSJPWORK/CAN-FD_4ch_HAT)
- [回路図](/docs/CAN-FD_4ch_HAT.pdf)
- [MCP2518データシート](https://ww1.microchip.com/downloads/aemDocuments/documents/OTH/ProductDocuments/DataSheets/External-CAN-FD-Controller-with-SPI-Interface-DS20006027B.pdf)
- [MCP2526FDデータシート](https://ww1.microchip.com/downloads/aemDocuments/documents/OTH/ProductDocuments/DataSheets/20005284A.pdf) 

- Rasperry Pi向け利用方法
  - [/boot/config.txt](examples/config.txt)
  - [/etc/udev/rules.d/70-persistent-net.rules](examples/70-persistent-net.rules)
  - [/home/pi/up.sh](examples/up.sh)
- [Arduinoライブラリ acan2517FD](https://github.com/pierremolinaro/acan2517FD)
- [Arduinoライブラリ acan2517](https://github.com/pierremolinaro/acan2517)