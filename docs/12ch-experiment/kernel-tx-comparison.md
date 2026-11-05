# Linux 6.6.47の高負荷CAN送信停止と12ch実験の修正

2026-11-04のソース調査。上流stable v6.6.47には、送信完了FIFO（TEF）の件数計算が高負荷時に送信を停止させ得る既知の問題がある。今回のRX保護は同じMCP2518FD errataの受信側に対応している。保存した対策版のTX・TEFソースは、実験のRaspberry Pi Linux 6.6.31系の基準ソースとバイト単位で一致した。

報告機の完全な `uname -r`、配布パッケージ、ロードしたモジュール、停止時ログは未確認。以下の6.6.47は上流stableタグを指す。配布版の取り込み状況と、報告事象の原因は個別確認が必要。

## 送信停止につながる経路

MCPドライバーはTXリングを使い切ると送信キューを止める。送信完了イベントをTEFから回収してTXリングのtailを進め、空きができるとキューを再開する。6.6.47の `mcp251xfd_get_tef_len()` は、ハードウェア側のTX FIFOが満杯かどうかを使って、未処理TEFが一周分ある場合を判定していた。全フレームを送信済みでTX FIFOは空、ドライバー側は完了未回収でリングに空きがない場合、位置の差が0となり、TEFを回収できない。キューを再開するための空きも戻らない。[v6.6.47 TX](https://github.com/gregkh/linux/blob/v6.6.47/drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c)・[v6.6.47 TEF](https://github.com/gregkh/linux/blob/v6.6.47/drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c)

- v6.6.61にはTX FIFOが空かつソフト側のTXリングに空きがない場合を扱う修正が入った。[6.6.61変更履歴](https://cdn.kernel.org/pub/linux/kernel/v6.x/ChangeLog-6.6.61)・[上流コミット](https://github.com/torvalds/linux/commit/3c1c18551e6ac1b988d0a05c5650e3f6c95a1b8a)
- v6.6.66には、TX FIFOの空フラグ自体が信用できない場合の補足回避策も入った。位置差0、半分未満、ソフト側空きなしを組み合わせて完了件数を判断する。[6.6.66リリース告知](https://lkml.iu.edu/hypermail/linux/kernel/2412.1/09927.html)
- 照合したv6.6.161、v7.3.1、v7.4-rc1、Raspberry Piの `rpi-6.18.y` にはこのTEF判定がある。4本の `mcp251xfd-tef.c` は取得したスナップショット間で一致。最新側の版は調査時点のkernel.orgの掲載に従った。[kernel.org](https://www.kernel.org/)・[v7.4-rc1 TEF](https://github.com/torvalds/linux/blob/v7.4-rc1/drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c)・[Raspberry Pi比較時のHEAD](https://github.com/raspberrypi/linux/tree/a4985478de14b3a83c8e04fed68377c1bdae735d/drivers/net/can/spi/mcp251xfd)

## 今回の変更との対応

| 項目 | 今回の実験 | 現行ソースと送信停止との関係 |
|---|---|---|
| RXの古い記録を検出し、有効分だけUINC | FIFOごとのHW時刻、受信可能数、時刻の開始順序を変更 | v6.6.161、v7.3.1、v7.4-rc1、Pi 6.18系に同系統のRX保護と時刻開始処理がある。RXの欠落・重複を対象とし、TEF件数はこの変更の対象外 |
| TX／TEF | 対策版アーカイブのTX・TEFソースはPi 6.6.31系の基準と同一 | 6.6.47のTEF実装はこの基準より新しい。今回の3時間合格から、6.6.47のTEF問題が修正されたとは判定できない |
| MCP共有IRQを1巡で戻す、SPI IRQをCPU分散 | 共有相手へ処理機会を返し、SPI処理のCPU集中を軽減 | TEF回収の遅れに影響する可能性がある。比較したPi 6.18とv7.4-rc1のMCP IRQハンドラーには通常経路の1巡制限がない |
| DesignWare SPIのTX FIFO prefill | SPI送信開始前にFIFOを充填する試験版 | TXオブジェクト書き込みやTEF読み出しにも同じSPI経路を使う。比較したPi 6.18とv7.4-rc1の通常IRQ転送は、コントローラーを有効化してIRQを設定し、ハンドラーでFIFOを補充する。試験版と同じ実装が入ったとは判断できない |
| coalescing、送信キュー、SPI速度・CS保持 | 試験時の設定を固定 | 受付拒否の出る負荷やSPI通信の余裕に影響し得る。TEF判定式の修正とは別 |

[現行RX](https://github.com/torvalds/linux/blob/v7.4-rc1/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c)・[現行MCP IRQ](https://github.com/torvalds/linux/blob/v7.4-rc1/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c)・[Pi 6.18 SPI](https://github.com/raspberrypi/linux/blob/a4985478de14b3a83c8e04fed68377c1bdae735d/drivers/spi/spi-dw-core.c)

## 実機で切り分けるときの判定材料

| 停止時に確認するもの | 切り分け |
|---|---|
| `ENOBUFS` と `tc -s qdisc` の廃棄が増え、TX完了も進む | 送信要求が処理能力を超えた場合の受付拒否。今回のClassic過負荷試験ではこの形を確認 |
| 負荷を下げてもTX完了が増えず、TXリングに空きが戻らない | TEFの回収停止を確認する。TEF処理ログと対応するソース版が必要 |
| `BUS-OFF`、CANエラーカウンター上昇 | CAN線側のエラー、ACK、タイミングなどを確認 |
| SPI timeout、SPI FIFO overflow、CRCエラー、IRQハンドラーのエラー | SPI通信やIRQ処理の異常を確認。TEF処理中に見える場合もSPI側の失敗とTEF件数の誤判定を区別する |

現行版での高負荷試験は未実施。古いRXパッチ一式を現行へ再適用する判断より先に、現行ドライバーで同じ配線・負荷を再測定し、必要ならIRQ分散、共有IRQの1巡化、SPI prefillの寄与を個別に比較する。
