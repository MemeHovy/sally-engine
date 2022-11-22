package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;

class WarningState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

        leftState = false;

		var bg:FlxSprite = new FlxSprite(0, FlxG.height * 0.4).loadGraphic(Paths.image('pokehelldevs'));
        bg.alpha = 0;
		bg.scale.set(1.5,1.5);
        add(bg);

        FlxTween.tween(bg, {alpha: 1}, 15, {startDelay: 3});

		warnText = new FlxText(0, 0, FlxG.width,
			#if DEVBUILD
			"Greetings, you have made yourself completely clear.\nUnderstood.\nI am your humble servant, will follow you to the utmost...\n\n(This is a beta build. Expect bugs and broken stuff)\n(Press Enter to continue)"
			#else
			"Hey, thanks for "+
            #if !html5 "downloading the mod!"+ #else "playing the mod online!" + #end
            "\n\nNobody barely records any gameplay footage on Youtube, so I'm glad you're here.\n"+
            #if html5 "Also, this mod isn't fully compatible with html5 so consider downloading on gamebanana."+ #end
            "\nReport any bugs you see and remember to have fun playing <3 -The devs of pokehell\n\n(Press Enter to continue)"#end,
			32);
		warnText.setFormat(Paths.font("righteous.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		warnText.screenCenter();
        bg.screenCenter();
        warnText.borderSize = 2;
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT || controls.BACK) {
				leftState = true;
				FlxG.sound.play(Paths.sound('scrollMenu'));
				FlxTween.tween(FlxG.camera, {zoom: 0.2}, 1, {ease: FlxEase.quadIn,startDelay: .5});
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new MainMenuState());
					}
				});
			}
			#if mobile
				for (touch in FlxG.touches.list)
				{
					if (touch.justPressed)
					{
						leftState = true;
						FlxG.sound.play(Paths.sound('scrollMenu'));
						FlxTween.tween(FlxG.camera, {zoom: 0.2}, 1, {ease: FlxEase.quadIn,startDelay: .5});
						FlxTween.tween(warnText, {alpha: 0}, 1, {
							onComplete: function (twn:FlxTween) {
								MusicBeatState.switchState(new MainMenuState());
							}
						});
					}
				}
			#end
		
		}
		super.update(elapsed);
	}
}
