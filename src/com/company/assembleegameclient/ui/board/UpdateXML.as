//com.company.assembleegameclient.ui.board.UpdateXML

package com.company.assembleegameclient.ui.board {
public class UpdateXML {

    public static var protipsXML:Class = EmbedUpdate;

    public var version:Vector.<String> = new Vector.<String>(0);
    public var patches:Vector.<String> = new Vector.<String>(0);

    public function UpdateXML() {
        this.makeTipsVector();
    }

    private function makeTipsVector():void {
        var _local_1:String;
        var _local_2:XML = XML(new protipsXML());
        for (_local_1 in _local_2.Article) {
            this.version.push(_local_2.Article.version[_local_1]);
            this.patches.push(_local_2.Article.patches[_local_1]);
        }
    }


}
}//package com.company.assembleegameclient.ui.board

