package yy;

/**Represents a 2.3 font*/
@:forward
abstract YyFont(YyFontImpl) from YyFontImpl to YyFontImpl {
	//

	/**
	 * Create a new YyFont with the default values found in 2.3
	 */
	public static function generateDefault(parent: YyResourceRef, name: String):YyFont {
		return {
			"hinting": 0,
			"glyphOperations": 0,
			"interpreter": 0,
			"pointRounding": 0,
			"fontName": "Arial",
			"styleName": "Regular",
			"size": 12.0,
			"bold": false,
			"italic": false,
			"charset": 0,
			"AntiAlias": 1,
			"first": 0,
			"last": 0,
			"sampleText": "abcdefg ABCDEFG\n0123456789 .,<>\"'&!?\nthe quick brown fox jumps over the lazy dinosaur\nTHE QUICK BROWN FOX JUMPS OVER THE LAZY DINOSAUR\nDefault character: ▯ (9647)",
			"includeTTF": false,
			"TTFName": "",
			"textureGroupId": {
			  "name": "Default",
			  "path": "texturegroups/Default",
			},
			"ascenderOffset": 0,
			"glyphs": {},
			"kerningPairs": [],
			"ranges": [
			  {"lower":32,"upper":127,},
			  {"lower":9647,"upper":9647,},
			],
			"regenerateBitmap": false,
			"canGenerateBitmap": true,
			"maintainGms1Font": false,
			"parent": parent,
			"resourceVersion": "1.0",
			"name": name,
			"tags": [],
			"resourceType": "GMFont",
		}
	}

	/**
	 * Add characters to the font ranges of the font, creating and merging ranges as necessary
	 * @param letters letters to add to the range
	 */
	public function addCharacters(letters:String) {
		var letterCodes: Array<Int> = new Array();
		for (letter in StringTools.iterator(letters)) {
			letterCodes.push(letter);
		}

		// Backwards sort, we want to pop smaller values first
		letterCodes.sort((a, b) -> b-a);

		
		var last:YyFontRange = null;
		var next:YyFontRange = this.ranges.length == 0 ? null : this.ranges[0];
		var index = 0;

		while (letterCodes.length > 0) {
			var letterCode = letterCodes.pop();

			// Always stay lower than next.lower
			while (next != null && letterCode > next.lower) {
				last = next;
				index++;
				next = this.ranges[index];
			}

			// We're inside last, skip
			if (last != null && last.upper >= letterCode) {
				continue;
			}

			// Add 1 to last.upper if we're on the edge
			if (last != null && last.upper+1 == letterCode) {
				last.upper = letterCode;

				// Bridge next and last if we're on the edge
				if (next != null && last.upper+1 == next.lower) {
					next.lower = last.lower;
					this.ranges.remove(last);
					last = next;
					next = this.ranges[index]; // Since we removed last the index is now at the proper next spot
				}
				continue;
			}

			// Add 1 to next lower if we're on the edge
			if (next != null && next.lower-1 == letterCode) {
				next.lower = letterCode;
				continue;
			}

			// No adding, this means we're creating a new range for us.
			last = {lower:letterCode, upper: letterCode};
			this.ranges.insert(index, last);
			index++;
		}
	}

	/**
	 * Returns all characters in the font as a string
	 */
	public function getAllCharacters(): String {
		var str = "";
		for (range in this.ranges) {
			for (i in range.lower...range.upper+1) {
				str+= String.fromCharCode(i);
			}
		}

		return str;
	}
}

typedef YyFontImpl = {
	>YyResource,
	hinting:Int,
	/**Bitmask holding various operations*/
	glyphOperations:Int,
	interpreter:Int,
	pointRounding:Int,
	fontName:String,
	styleName:String,
	size:Float,
	bold:Bool,
	italic:Bool,
	charset:Int,
	AntiAlias:Int,
	first:Int,
	last:Int,
	sampleText:String,
	includeTTF:Bool,
	TTFName:String,
	textureGroupId:{
		name:String,
		path:String
	},
	ascenderOffset:Int,
	glyphs:{},
	kerningPairs:Array<Any>,
	ranges:Array<YyFontRange>,
	regenerateBitmap:Bool,
	canGenerateBitmap:Bool,
	maintainGms1Font:Bool,
};

typedef YyFontRange = {
	lower: Int,
	upper: Int
}
