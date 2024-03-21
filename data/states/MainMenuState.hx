var optionShit:Array<String> = CoolUtil.coolTextFile(Paths.txt("config/menuItems"));

function postCreate() {
	for (i=>option in optionShit) {
		menuItems.members[i].y = 20 + (i * 140);
		menuItems.members[i].scale.set(0.8, 0.8);
	}
}


function onSelectItem() {

    var daChoice:String = optionShit[curSelected];

    switch (daChoice) {
		case 'clicker':
			FlxG.switchState(new ModState('Custom/BotomyState'));
	}
}
