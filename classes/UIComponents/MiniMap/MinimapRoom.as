﻿package classes.UIComponents.MiniMap
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.utils.getDefinitionByName;
	import classes.UIComponents.UIStyleSettings;
	import classes.Resources.MapIcons;
	
	/**
	 * ...
	 * @author Gedan
	 */
	public class MinimapRoom extends Sprite
	{
		private var _sizeX:int;
		private var _sizeY:int;
		
		// I fucking hate you Adobe.
		private var _roomIcon:Sprite;
		private var _icons:Array;
		private var _currIconId:int; 
		private var _hazardMask:Sprite;
		
		public function MinimapRoom(sizeX:int, sizeY:int) 
		{
			// Size information is used to figure out the "parent rooms" size without having to do bullshit like:
			// this.parent.getChildByName(somename).width etc, fuck that noise
			_sizeX = sizeX;
			_sizeY = sizeY;
			_currIconId = -1;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			this.Build();
			
			_hazardMask = new MapIcons.Map_Hazard();
			//this.mask = _hazardMask;
			//this.addChild(_hazardMask);
		}
		
		private function Build():void
		{
			var i:int;
			_roomIcon = new Sprite();
			_roomIcon.graphics.beginFill(UIStyleSettings.gDebugPaneBackgroundColour, 1);
			_roomIcon.graphics.drawRoundRect(0, 0, _sizeX, _sizeY, 5);
			_roomIcon.graphics.endFill();
			this.addChild(_roomIcon);
			
			this._icons = new Array();
			
			for (i = 0; i < MiniMap.ICON_NAMES.length; i++)
			{
				var classType:Class = MapIcons[MiniMap.ICON_NAMES[i]];
				_icons[i] = new classType();
				_icons[i].name = String(MiniMap.ICON_NAMES[i]);
				this.addChild(_icons[i]);
				_icons[i].visible = false;
				
				_icons[i].transform.colorTransform = UIStyleSettings.gWhiteColourTransform;
				
				var tHeight:Number = _sizeY - 8;
				var tWidth:Number = _sizeY - 8;
				var ratio:Number = tHeight / tWidth;
				
				if (_icons[i].width * ratio > _icons[i].height)
				{
					ratio = tWidth / _icons[i].width;
				}
				else
				{
					ratio = tHeight / _icons[i].height;
				}
				
				_icons[i].width *= ratio;
				_icons[i].height *= ratio;
				
				
				_icons[i].x = (_sizeX - _icons[i].width) / 2;
				_icons[i].y = (_sizeY - _icons[i].height) / 2;
			}
		}
		
		public function setColour(ct:ColorTransform):void
		{
			_roomIcon.transform.colorTransform = ct;
		}
		
		public function setIcon(iconId:int):void
		{
			// No change required
			if (_currIconId == iconId)
				return;
			
			// Invalid supplied icon IDs
			if (iconId >= MiniMap.ICONS_MAX || iconId < -1)
				return;
			
			// Valid icon that we don't want to hide
			if (iconId != -1)
				_icons[iconId].visible = true;
			
			// Hide current, make new current
			if (_currIconId != -1)
				_icons[_currIconId].visible = false;
				
			_currIconId = iconId;
		}
		
		public function showHazard():void
		{
			if (_hazardMask.parent == null) this.addChild(_hazardMask);
			this.mask = _hazardMask;
		}
		
		public function hideHazard():void
		{
			if (_hazardMask.parent != null) this.removeChild(_hazardMask);
			this.mask = null;
		}
	}

}