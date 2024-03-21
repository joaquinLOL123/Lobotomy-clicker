import funkin.backend.system.framerate.Framerate;
import flixel.FlxObject;
import sys.FileSystem;
import Sys;

//Camera
var camHUD:FlxCamera;

//Sprites
var geedee:FlxSprite;
var ground:FlxSprite;
var gLine:FlxSprite;
var normalDif:FlxSprite;

//Groups, Arrays and stuff
var faces:Array<String> = ["Normal", "Easy"];
var faceGroup:FlxTypedGroup = new FlxTypedGroup();
var faceSoundGroup:FlxTypedGroup = new FlxTypedGroup();
var sounds:Array<String> = ["fireHole", "waterHill"];
var songPlaylist:Array<String>;
var groundGroup:FlxTypedGroup = new FlxTypedGroup();
var colors:Array<String> = [ "0x02fe2a", "0x00d2ff"];

//Music and Sounds
var firehole:FlxSound;
var BGM = FlxG.sound.music;

//UI
var logo:FlxSprite;
var countText:FunkinText = new FunkinText(10);
var arrowL:FlxSprite;
var arrowR:FlxSprite;

//Data
var clickCount:Int = 0;
var uhh:Float;
var curSelected:Int = 0;
var curSong:Int = 0;
var curSongName:String;
var camFollow:FlxObject;
var groundAmnt:Int = 4; //CHANGE IF YOU ADD LOTS OF FACES


function create() {
    //Initialization
    FlxG.mouse.visible = true;
    if (FlxG.save.data.clickCount != null) 
        clickCount = FlxG.save.data.clickCount;

    //Add Camera
    camHUD = new FlxCamera();
    camHUD.bgColor = 0;
    FlxG.cameras.add(camHUD, false);

    //Add Sprites
    geedee = new FlxSprite(0, -1000).loadGraphic(Paths.image('menus/clicker/bg'));
    geedee.updateHitbox();
    geedee.antialiasing = true;
    geedee.scrollFactor.set(0.05);
    add(geedee);

    for (i in 0...groundAmnt) {
        ground = new FlxSprite(512 * i, 500).loadGraphic(Paths.image('menus/clicker/groundSquare'));
        ground.antialiasing = true;
        ground.ID = i;
        ground.updateHitbox();
        ground.scrollFactor.set(0.5);
        groundGroup.add(ground);
    }

    gLine = new FlxSprite().loadGraphic(Paths.image('menus/clicker/groundLine'));
    gLine.screenCenter(FlxAxes.X);
    gLine.y = groundGroup.members[0].y;
    gLine.scrollFactor.set(0);
    gLine.ID = -1;
    groundGroup.add(gLine);
    add(groundGroup);

    for (i => face in faces) {

        normalDif = new FlxSprite(1080 + (640 * i), 0).loadGraphic(Paths.image('menus/clicker/faces/' + face));
        normalDif.screenCenter(FlxAxes.Y);
        normalDif.antialiasing = true;
        normalDif.ID = i;
        normalDif.updateHitbox();
        faceGroup.add(normalDif);
    }
    add(faceGroup);

    //Add Sounds
    for (i=>sound in sounds) {
        firehole = new FlxSound();
        firehole.loadEmbedded(Paths.sound(sound));
        firehole.ID = i;
        faceSoundGroup.add(firehole);
    }
    switchSong();

    //Add UI

    countText.y = Framerate.codenameBuildField.y + 30;
    countText.size = 20;
    countText.text = 'Clicks: ' + clickCount;
    countText.scrollFactor.set();
    add(countText);
    countText.cameras = [camHUD];

    camFollow = new FlxObject(0, 0, 1, 1);
	add(camFollow);
    FlxG.camera.follow(camFollow, null, 0.1);

    // volume = new FlxSlider(BGM, "volume", 100, 100, 0, 100);
    // add(volume);
    // volume.cameras = [camHUD];
    //damn it why doesn't flixel.addons.ui work in CNE

    arrowL = new FlxSprite(10).loadGraphic(Paths.image('menus/clicker/Ui/arrow'));
    arrowL.scale.set(0.5, 0.5);
    arrowL.screenCenter(FlxAxes.Y);
    arrowL.cameras = [camHUD];
    arrowL.antialiasing = true;
    arrowL.flipX = true;
    add(arrowL);

    arrowR = new FlxSprite(FlxG.width - 116).loadGraphic(Paths.image('menus/clicker/Ui/arrow'));
    arrowR.scale.set(0.5, 0.5);
    arrowR.screenCenter(FlxAxes.Y);
    arrowR.cameras = [camHUD];
    arrowR.antialiasing = true;
    add(arrowR);


    logo = new FlxSprite().loadGraphic(Paths.image('menus/clicker/Ui/logo'));
    logo.scale.set(0.6, 0.6);
    logo.screenCenter(FlxAxes.X);
    logo.antialiasing = true;
    logo.cameras = [camHUD];
    add(logo);

    changeItem();
    

}

function update() {

    faceGroup.forEach(function(spr:FlxSprite) {
        uhh = CoolUtil.fpsLerp(spr.scale.x, 0.8, 0.1);
        spr.scale.set(uhh, uhh);
    });

    if (controls.BACK) {
        FlxG.switchState(new MainMenuState());
        FlxG.sound.playMusic(Paths.music("freakyMenu"));
        FlxG.mouse.visible = false;

        //SAVE PROGRESS
        FlxG.save.data.clickCount = clickCount;
        FlxG.save.flush();
    }
    if (controls.LEFT_P) {
        changeItem(-1);
    }
    if (controls.RIGHT_P) {
        changeItem(1);
    }
    if (controls.ACCEPT) {
        
        faceSoundGroup.forEach(function(sound:FlxSound) {
        
            if (sound.ID == curSelected) {

                faceSoundGroup.members[curSelected].pitch = FlxG.random.float(0.5, 2.0);
                faceSoundGroup.members[curSelected].play(true);
            }
        });

        faceGroup.members[curSelected].scale.set(faceGroup.members[curSelected].scale.x + 0.12, faceGroup.members[curSelected].scale.x + 0.12);

        clickCount += 1;
        countText.text = 'Clicks: ' + clickCount;
    }
}



function changeItem(yea:Int = 0) {

    curSelected = FlxMath.wrap(curSelected += yea, 0, faceGroup.length - 1);
    trace(faceGroup.length);
    trace(curSelected);

    faceGroup.forEach(function(spr:FlxSprite) {

        if (spr.ID == curSelected) {

            var mid = spr.getGraphicMidpoint();
            camFollow.x = mid.x;
            camFollow.y = mid.y;
			mid.put();
            trace(spr.ID);
            
            geedee.color = FlxColor.fromString(colors[curSelected]);
            groundGroup.forEach(function(spr:FlxSprite) {
                if (spr.ID != -1)
                    spr.color = FlxColor.fromString(colors[curSelected]);
            });
        }
    });
}

function switchSong(yea:Int = 0) {
    songPlaylist = Paths.getFolderContent("music", false, false); //refreshes music folder content so songs you add get included
    curSong = FlxMath.wrap(curSong += yea, 0, songPlaylist.length - 1);
    curSongName = songPlaylist[curSong];

	if (BGM.active)
	{
		BGM.stop();
	}

    BGM.loadEmbedded(Paths.getPath("music/" + curSongName), false);
    BGM.volume = 0.5;
    BGM.onComplete = function() {
        new FlxTimer().start(0.5, function() { //added delay because it doesnt work otherwise
            switchSong(-1);
        });
    }
	BGM.persist = true;

    trace("playin!!");
    BGM.play();

}
