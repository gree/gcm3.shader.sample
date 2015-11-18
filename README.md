# gcm3.shader.sample
本リポジトリでは、2015/11/12に開催された[GREE Creators' Meetup 第3回](http://connpass.com/event/20624/) TrackC：「アーティストのためのプログラマブルシェーダ講座」でご紹介したサンプルプログラムを公開しています。
- [講演資料](http://www.slideshare.net/greeart/gcm3)
- [デモ動画](https://youtu.be/cQZiO1QV9cw)

# 使い方
1. 任意のパスにディレクトリを作成してくだい(例:gcm3.shader.sample)
2. 1.のディレクトリに、本リポジトリをCloneして下さい
3. 1.のディレクトリを、Unity (5.2以降)で開いて下さい



# 内容
- 01_Hemisphere
	- 半球シェーダのサンプル
	- CurveZ / CurveXの値を変更することで、頂点の位置を変更できます
- 02_RimLight
	- リムライトシェーダのサンプル
	- Rim Colorでリムの色を変更できます
	- Rim Powerでリムの幅を変更できます
	- Standard タイプのシェーダもあります
- 03_DepthMask
	- デプスマスクのサンプル
	- シーン中の、double_cube_DepthMaskにデプスマスクが適応されています。double_cube_Standardと比べて見てください。
- 04_UI
	- Shader on UIのサンプル
	- シーン中の、Canvas/SineWave が、Sine波でゆがむUIです
	- シーン中の、Canvas/Bokeh が、ぼかしUIです
- 05_PostEffect
	- ポストエフェクトのサンプルです。
	- シーン中の、Main CameraにアサインされているFeedbackEffect.csのプロパティを操作してください