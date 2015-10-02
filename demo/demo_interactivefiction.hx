var game = " 
title = The best Visual Novel ever!
author = Stephen Lavelle
homepage = www.increpare.com

background = #ffffff
foreground = #0000ff
text = #000000

Carlos = ZMex$2NmArrFw5txpykaaeaaBZ6acb=bPacbAguja565daaafqBY67ur6Qd2ayrrubpabTatLXayefiagfdyiabvvvqk7x6Pvqbrq6a
Rob = ZMex$2NmArrFw5txpykaaeaaBZ6acb=bPacbAguja565daaafqBY67ur6Qd2ayrrubpabTatLXayefiagfdyiabvvvqk7x6Pvqbrq6a

Carl : Hey, how're you doing?
Rob : I'm doing fine. Where do you want to go for food?

Where do you want to go?
The supermarket sounds good! -> SUPERMARKET
I need to get some new clothes. -> CLOTHES SHOP

SUPERMARKET

Carl : Wow, it's busy here, how about we get some food?
FOODSHOP



";

var portraitScale=2;
var boxWidth=200;
Gfx.loadimagestring("phil","ZT8rCuzGsap6bZapYaZSd36pYaZSdZ6mgaKydZ6pYaZSd36i8aaaa");
Gfx.loadimagestring("chris","ZTG7eyaFK6pWbZKpZ7ZZpZZYm5YXZZZZZZSpZIXYVNZYhZKpYapKa");
Gfx.loadimagestring("up_arrow","3SaaapZZZSK4pRY4h7Saa");
Gfx.loadimagestring("down_arrow","3SaaapZZZSa4h7TZJLSma");

Text.setfont(Font.NOKIA);
var xmargin=3;
var ymargin=3;
var portraitwidth=16;
var portraitheight=16;
var windowbordersize=3;
var backgroundcol = 0x215e5e;
var windowcol = 0xdb9e23;
var textcol = 0xf9dede;
var textboxwidth=150;
function colorLerp(c1,c2,a){
  var hsl1 = [Gfx.gethue(c1),Gfx.getsaturation(c1),Gfx.getlightness(c1)];
  var hsl2 = [Gfx.gethue(c2),Gfx.getsaturation(c2),Gfx.getlightness(c2)];
  var hsl3 = [a*hsl1[0]+(1-a)*hsl2[0],a*hsl1[1]+(1-a)*hsl2[1],a*hsl1[2]+(1-a)*hsl2[2]];
  return Gfx.hsl(hsl1[0],hsl1[1],hsl3[2]);
}

function wrap(s,maxl){
  var words = s.split(" ");
  var result="";
  var curline="";
  var curword="";
  for(i in 0...words.length){
    var w = words[i];
    if (w=="\n"){
      if (result.length>0){
        result = result+"\n";
      }
      result = result + curline;
      curline="";
      continue;
    }
    if (curline.length>0){
      curline+=" ";
    }
    var l = curline+w;
    if(Text.len(l)>maxl){
      if (result.length>0){
        result = result+"\n";
      }
      result = result + curline;
      curline=w;
    } else {
      curline=l;    
    }
  }
  if (result.length>0){
    result = result+"\n";
  }
  result = result+curline;
  return result;
}

function linecount(s) {
  var count=1;
  for (i in 0...s.length){
    if (s[i]=="\n"){
      count++;
    }
  }
  return count;
}


var uppressed=0;
var downpressed=0;
function drawdialog(h,person,text,?choices){
  var isnpc=person=="player"?0:1;
  var s = text;
  var wrappeds = wrap(s,textboxwidth); 
  var lines = linecount(wrappeds);

  var highlightcol = colorLerp(windowcol,backgroundcol,0.5);
  var boxheight=isnpc*portraitheight+2*windowbordersize+Text.height();
  var height = Text.height()*(lines+1);
  if (height+windowbordersize>boxheight){
    boxheight=height+windowbordersize;
  }
  var yoffset = Gfx.screenheight-h-boxheight-ymargin*2;
  var boxwidth=portraitwidth+3*windowbordersize+textboxwidth;
  var lxmargin=xmargin;
  if (isnpc==false){
    //boxwidth-=portraitwidth+windowbordersize;
    lxmargin=Gfx.screenwidth-xmargin-boxwidth; 
  }
  Gfx.fillbox(lxmargin+1, yoffset+ymargin+1, boxwidth, boxheight, highlightcol);
  Gfx.fillbox(lxmargin, yoffset+ymargin, boxwidth, boxheight, windowcol);

  if (isnpc){
    Gfx.fillbox(lxmargin+windowbordersize-1, yoffset+ymargin+windowbordersize-1+Text.height(), portraitwidth+2, portraitheight+2, highlightcol);
    //   Gfx.scale(2,2,0,0);
    Gfx.drawimage(lxmargin+windowbordersize, yoffset+ymargin+windowbordersize+Text.height(), "phil");  
  } else {    
    Gfx.fillbox(lxmargin+2*windowbordersize-1+textboxwidth, yoffset+ymargin+windowbordersize-1+Text.height(), portraitwidth+2, portraitheight+2, highlightcol);
    //   Gfx.scale(2,2,0,0);
    Gfx.drawimage(lxmargin+2*windowbordersize+textboxwidth, yoffset+ymargin+windowbordersize+Text.height(), "phil");  
  }

  Text.display(lxmargin+windowbordersize+windowbordersize*isnpc+isnpc*portraitwidth-1,yoffset+ymargin+windowbordersize-1,person,highlightcol);

  Text.display(lxmargin+windowbordersize+windowbordersize*isnpc+isnpc*portraitwidth,yoffset+ymargin+windowbordersize+Text.height(),wrappeds,textcol);
  return boxheight+1;
}


function drawchoice(h,person,text){
  var isnpc=0;
  var s = text;
  var wrappeds = wrap(s,textboxwidth); 
  var lines = linecount(wrappeds);

  var highlightcol = colorLerp(windowcol,backgroundcol,0.5);
  var highlightcol2 = colorLerp(windowcol,backgroundcol,0.25);
  var boxheight=portraitheight+2*windowbordersize+Text.height();
  var height = Text.height()*(lines+1);
  if (height+windowbordersize>boxheight){
    boxheight=height+windowbordersize;
  }
  var yoffset = Gfx.screenheight-h-boxheight-ymargin*2;
  var boxwidth=portraitwidth+3*windowbordersize+textboxwidth;
  var lxmargin=xmargin;
  if (isnpc==false){
    //    boxwidth-=portraitwidth+windowbordersize;
    lxmargin=Gfx.screenwidth-xmargin-boxwidth; 
  }
  Gfx.fillbox(lxmargin+1, yoffset+ymargin+1, boxwidth, boxheight, highlightcol2);
  Gfx.fillbox(lxmargin, yoffset+ymargin, boxwidth, boxheight, highlightcol);
  Gfx.fillbox(lxmargin, yoffset+ymargin+Text.height()/2, boxwidth-portraitwidth-xmargin*2, boxheight-Text.height(), windowcol);
  
  if (isnpc){
    Gfx.fillbox(lxmargin+windowbordersize-1, yoffset+ymargin+windowbordersize-1+Text.height(), portraitwidth+2, portraitheight+2, highlightcol);
    //   Gfx.scale(2,2,0,0);
    Gfx.drawimage(lxmargin+windowbordersize, yoffset+ymargin+windowbordersize+Text.height(), "phil");  
  } else {    
 //   Gfx.fillbox(lxmargin+2*windowbordersize-1+textboxwidth, yoffset+ymargin+windowbordersize-1+Text.height(), portraitwidth+2, portraitheight+2, highlightcol);
    //   Gfx.scale(2,2,0,0);
//    Gfx.drawimage(lxmargin+2*windowbordersize+textboxwidth, yoffset+ymargin+windowbordersize+Text.height(), "phil");  
  }

//   Text.display(lxmargin+windowbordersize+windowbordersize*isnpc+isnpc*portraitwidth-1,yoffset+ymargin+windowbordersize-1,person,highlightcol);
//	Text.display(lxmargin+boxwidth-portraitwidth-xmargin, yoffset+ymargin+Text.height()/4+boxheight-Text.height()*2+ymargin,"^");
 
  if (uppressed>0){
	  Gfx.fillbox(lxmargin+boxwidth-portraitwidth-xmargin+1, yoffset+ymargin+Text.height()/4+1,portraitwidth , Text.height()*1.3, windowcol);
		Gfx.drawimage(1+lxmargin+boxwidth-portraitwidth-xmargin+portraitwidth/2-4,1+ yoffset+ymargin+Text.height()/4+3,"up_arrow");
  } else {
	  Gfx.fillbox(lxmargin+boxwidth-portraitwidth-xmargin+1, yoffset+ymargin+Text.height()/4+1,portraitwidth , Text.height()*1.3, highlightcol2);
	  Gfx.fillbox(lxmargin+boxwidth-portraitwidth-xmargin, yoffset+ymargin+Text.height()/4,portraitwidth , Text.height()*1.3, windowcol);
		Gfx.drawimage(lxmargin+boxwidth-portraitwidth-xmargin+portraitwidth/2-4, yoffset+ymargin+Text.height()/4+3,"up_arrow");    
  }
  
  if (downpressed>0){
	  Gfx.fillbox(lxmargin+boxwidth-portraitwidth-xmargin+1, yoffset+ymargin+Text.height()/4+boxheight-Text.height()*2+ymargin+1,portraitwidth , Text.height()*1.3, windowcol);
	  Gfx.drawimage(1+lxmargin+boxwidth-portraitwidth-xmargin+portraitwidth/2-4,1+ yoffset+ymargin+Text.height()/4+boxheight-Text.height()*2+ymargin+2,"down_arrow");
  } else {
	  Gfx.fillbox(lxmargin+boxwidth-portraitwidth-xmargin+1, yoffset+ymargin+Text.height()/4+boxheight-Text.height()*2+ymargin+1,portraitwidth , Text.height()*1.3, highlightcol2);
  	Gfx.fillbox(lxmargin+boxwidth-portraitwidth-xmargin, yoffset+ymargin+Text.height()/4+boxheight-Text.height()*2+ymargin,portraitwidth , Text.height()*1.3, windowcol);
	  Gfx.drawimage(lxmargin+boxwidth-portraitwidth-xmargin+portraitwidth/2-4, yoffset+ymargin+Text.height()/4+boxheight-Text.height()*2+ymargin+2,"down_arrow");
  }
  
	
  
  //  var centerx=lxmargin+textboxwidth/2
  Text.display(lxmargin+windowbordersize+windowbordersize*isnpc+isnpc*portraitwidth,yoffset+ymargin+windowbordersize+Text.height()/2,wrappeds,textcol);
  return boxheight+1;
}

var options =["hey","what am i to \ndo aaa \n oopp\nasdf \nh","really","aah go away"];
var optionIndex=0;
function update(){  
  if (uppressed>0){
    uppressed--;
  }
  if (downpressed>0){
    downpressed--;
  }
  
  Gfx.clearscreen(backgroundcol);
  if (Input.delaypressed(Key.UP, 10)){
    uppressed=4;
    optionIndex=(optionIndex-1+options.length)%options.length;
  }
  if (Input.delaypressed(Key.DOWN, 10)){
    downpressed=4;
    optionIndex=(optionIndex+1+options.length)%options.length;
  }
  
  var h = drawchoice(0,"chris",options[optionIndex]);
  h+=ymargin;
  h+=drawdialog(h,"chris","hey\nbabe");
  h+=ymargin;
  h+=drawdialog(h,"player","hey are you there I hope a a a a a a a a?");
  h+=ymargin;
  h+=drawdialog(h,"chris","pix?");

}