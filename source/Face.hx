class Face extends flixel.FlxSprite {
    //custom class for the faces so it'll be easier to add them.

    public var soundName:String;
    public var daSound:FlxSound = new FlxSound();
    private var lerpX;
    private var lerpY;

    public function new(x:Float = 0, y:Float = 0, ?SimpleGraphic:Null<FlxGraphicAsset>,scale:Float = 1.0, image:String = "Normal", sound:String = "fireHole") {
        super(x, y);

        soundName = sound;

        loadGraphic(Paths.image("menus/clicker/" + image));
        firehole.loadEmbedded(Paths.sound('fireHole'));
    }

    public function update(elapsed:Float) {
        super(elapsed);

        lerpX = CoolUtil.fpsLerp(scale.x, scale, 0.1);
        lerpY = CoolUtil.fpsLerp(scale.y, scale, 0.1);
        scale.set(lerpX, lerpY);

        if (controls.ACCEPT) {
            onClick();
        }
    }

    public function onClick() {
        daSound.pitch = FlxG.random.float(0.5, 2.0);
        daSound.play(true);
        scale.set(scale.x + 0.12, scale.y + 0.12);
    }
    
}

//unused but i'll use and rework this soon....