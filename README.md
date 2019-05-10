# UMATracker

[![Build status](https://umatracker.vsrm.visualstudio.com/_apis/public/Release/badge/0f98e98a-73c9-4ba5-95b3-5f673ab00e9f/1/1)](https://umatracker.visualstudio.com/UMATracker-CI/_release?definitionId=1)

## Detail
See [Top Page](http://ymnk13.github.io/UMATracker/).

## Donwload
See [GitHub Releases Page](https://github.com/UMATracker/UMATracker/releases).

## References:
If you use UMATracker please cite Yamanaka and Takeuchi 2018 and if you use GroupTracker algorithm please also cite Fukunaga et al, 2015

     @article{yamanaka2018umatracker,
      title={UMATracker: an intuitive image-based tracking platform},
      author={Yamanaka, Osamu and Takeuchi, Rito},
      journal={Journal of Experimental Biology},
      volume={221},
      number={16},
      pages={jeb182469},
      year={2018},
      publisher={The Company of Biologists Ltd}
     }

     @article{fukunaga2015grouptracker,
       title={GroupTracker: video tracking system for multiple animals under severe occlusion},
       author={Fukunaga, Tsukasa and Kubota, Shoko and Oda, Shoji and Iwasaki, Wataru},
       journal={Computational biology and chemistry},
       volume={57},
       pages={39--45},
       year={2015},
       publisher={Elsevier}
      }


## Change Log

### 2019/03/05
* macOS版の起動時間・バイナリサイズ削減．

### 2019/02/25
* Azure DevOpsでビルドするようになった．

### 2018/04/24

#### Tracking

* Sketeton Estimatorでmis-detectionを無視できるようにした．

### 2018/04/04

#### Tracking

* 以下のショートカットが追加された．
    
    * "Ctrl-S" (Windows), "Command+S" (macOS)：Save Data.
    * "Ctrl-R" (Windows), "Command+R" (macOS)：Restart from This Frame.
    * "W" or "P" Key：Go to previous frame.
    * "Q" or "O" Key：Go to next frame.

### 2018/03/18

#### Tracking

* 手動トラッキングで失敗したときに，失敗したフレームからリスタートできるようになった
* トラッキング開始時に真っ黒なフレームを無視するようにした
    これによってビデオを事前に編集する必要がなくなった
* トラッキング途中に発生するトラッキングエラーを無視するオプションを追加した

### 2018/03/04

#### Tracking

* 手動トラッキング機能（Pochi-Pochi Tracking）追加

#### Area51

* Objectのセーブ・ロード機能を追加

#### Area51/TrackingCorrector

* フレーム番号が0から始まらないデータの読み込みに失敗するバグを修正

### 2017/08/09

#### Tracking

* 現在のスライダーバーの位置までしか正しくセーブされないバグを修正

### 2017/03/26

#### Area51

* 細かいバグの修正．

### 2017/03/24

* スライダをマウスでドラッグアンドドロップしたとき，指定した間隔通りに動かない問題を修正．

### 2017/03/23

#### FilterGenerator

* PolySelectorブロックにおいて任意の多角形をサポート．
* Binalizeせずフィルタをセーブしようとすると警告が出るようになった．

### 2017/03/14

#### Area51

* オブジェクト・コンボボックスの変更が，ビューへ即時反映されるよう変更．

### 2016/12/03

#### Tracking

#### TrackingCorrector

#### Area51

* FrameDeltaを指定して得られたデータを扱うときに正しく動作しない問題を修正．

#### Area51

* ROI DiagramにAxis Labelを表示するようにした．

### 2016/11/16

#### Tracking

#### TrackingCorrector

* マウススクロールでビデオプレイバックスライダーがスクロールされるようになった．

### 2016/11/08

#### FilterGenerator
* カラーパレットとゴミ箱がオフラインでも表示されるように修正した．

### 2016/06/29
* UI修正．

#### FilterGenerator
* 背景生成時，何フレーム使用するのかを表示するようになった．

#### Tracking
* 再推定に失敗するバグを修正．

#### Area51
* 任意の直線と各個体間の距離を算出できるようになった．

![line_dist](img/2016_06_29/uma_area51_linedist.png)

### 2016/06/26

#### FilterGenerator
* ビデオ出力機能のバグ修正（Windows版）．

#### Tracking
* SkeletonEstimatorの精度向上（Windows 64bit版）．

#### Area51
* 点・領域の座標を表示．
