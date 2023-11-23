package menus;

#if desktop
import backend.Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import data.Medals;
import backend.Paths;
import data.Controls;
import menus.MainMenuState;
import data.MusicBeatState;
import ui.Alphabet;
import data.ClientPrefs;
using StringTools;

class MedalsMenuState extends MusicBeatState
{
	#if MEDALS_ALLOWED
	var options:Array<String> = [];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	private var medalArray:Array<AttachedMedal> = [];
	private var medalIndex:Array<Int> = [];
	private var descText:FlxText;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Medals Menu", null);
		#end

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/mainmenu/menuBGMagenta'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuBG);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		Medals.loadMedals();
		for (i in 0...Medals.medalsStuff.length) {
			if(!Medals.medalsStuff[i][3] || Medals.medalsMap.exists(Medals.medalsStuff[i][2])) {
				options.push(Medals.medalsStuff[i]);
				medalIndex.push(i);
			}
		}

		for (i in 0...options.length) {
			var achieveName:String = Medals.medalsStuff[medalIndex[i]][2];
			var optionText:Alphabet = new Alphabet(280, 300, Medals.isMedalUnlocked(achieveName) ? Medals.medalsStuff[medalIndex[i]][0] : '?', false);
			optionText.isMenuItem = true;
			optionText.targetY = i - curSelected;
			optionText.snapToPosition();
			grpOptions.add(optionText);

			var icon:AttachedMedal = new AttachedMedal(optionText.x - 105, optionText.y, achieveName);
			icon.sprTracker = optionText;
			medalArray.push(icon);
			add(icon);
		}

		descText = new FlxText(150, 600, 980, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);
		changeSelection();

		super.create();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
	}

	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
			}
		}

		for (i in 0...medalArray.length) {
			medalArray[i].alpha = 0.6;
			if(i == curSelected) {
				medalArray[i].alpha = 1;
			}
		}
		descText.text = Medals.medalsStuff[medalIndex[curSelected]][1];
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	}
	#end
}
