# CAN FD 4ch HAT for Raspberry Pi
MCP2518 + MCP2562FD CAN FD 4ch HAT for Raspberry Pi

### 特徴
- Microchip社のMCP2518とMCP2562FDを使い、必要なコンデンサ、水晶振動子をセットにした4chのCAN FD HATです。
- SPI IFを使ってCANの送受信ができます。
- MCP2518の駆動電圧を3.3V(Rasperry Pi, ESP32向け)としております。
- 終端抵抗のあるなしをジャンパスイッチにて切り替えできます。
- MCP2518向けのドライバにて簡単に利用できます。
- (おまけ)3.3V駆動のESP32でも使うことはできます。

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