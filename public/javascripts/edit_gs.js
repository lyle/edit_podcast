function init() {
  initToolBlock();
  if (currentStatus == "new"){
		showHideSection('abstract','sec1btn')
  }else if(currentStatus == "live"){
	
		showHideSection('news','sec4btn')
  }else{
		showHideSection('pageContent','sec2btn')
  }
  
  showHidePeopleList('geekPeople','geeks_btn');
}
function sorting_off(target,toggle,offtext){
	Sortable.destroy(target);
	$(target).className = $(target).classNameOriginal;
	$(toggle).innerHTML = offtext;
}
function sort_toggle(target, url, toggle, ontext, offtext){
	if (toggle.text == ontext){
		//turn sort off
		sorting_off(target,toggle,offtext)
	}else{
		//turn sort on
		Sortable.create(target, {onUpdate:function(){new Ajax.Request(url, {asynchronous:true, evalScripts:true, parameters:Sortable.serialize(target)})}});
		//alert(Sortable.serialize(target));
		toggle.innerHTML = ontext;
		$(target).classNameOriginal = $(target).className;
		$(target).className = 'sortable ' + $(target).classNameOriginal;
	}
}
function changeClass(target, newClass) {
	$(target).className = newClass;
}
function initToolBlock() {
  if (window.innerHeight) {
	ht = window.innerHeight - 180;
  }else{
    ht = 300;
  }
  new Rico.Accordion( $('tools'), {panelHeight:268} );
 // if (window.innerWidth & window.innerWidth > 830) {
 //   toggleWidth($('ToolBlockminMaxBtn'),'toolBlock','<','none','>',160);
 // }
}

function toggleWithBlind(elem) {
  if ($(elem).style.display == 'none') {
    Effect.BlindDown(elem,{duration: 0.3});
  }else {
    Effect.BlindUp(elem,{duration: 0.2});
  }
}

function toggleWidth(buttonNode,targetNode, smallState, smallWidth, bigState, bigWidth) {
  if ( $(buttonNode).text == smallState ) {
    $(targetNode).style.width = bigWidth + "px";
    $('mTextHelp').style.width = bigWidth + "px";
    
    $(buttonNode).innerHTML = bigState;
  } else {
	if (smallWidth == 'none' ){
      $(targetNode).style.width = "";
    }else{
      $(targetNode).style.width = smallWidth + "px";
      $('mTextHelp').style.width = smallWidth + "px";
    }
    $(buttonNode).innerHTML = smallState;
  }
}

function showHideSection(activeSection, btn) {
  btnsWrap = $(btn).parentNode.parentNode.getElementsByTagName('li');
  for (var i=0; btnsWrap.length > i; i++) {
    removeClass(btnsWrap[i].getElementsByTagName('a')[0], "selected")
  }
  for (var i=0; $('pageSections').childNodes.length >i; i++) {
    if ($('pageSections').childNodes[i].nodeType == 1) {
    		$('pageSections').childNodes[i].style.display='none';
    }
  } 
  
  $(activeSection).style.display='block';
  addClass($(btn), "selected");
  $(btn).blur();
}
function showHidePeopleList(activeSection, btn) {
  btnsWrap = $(btn).parentNode.parentNode.getElementsByTagName('li');
  for (var i=0; btnsWrap.length > i; i++) {
    removeClass(btnsWrap[i], "selected")
    if (btnsWrap[i].firstChild == btn) {
      addClass(btnsWrap[i], "selected")
    }
    removeClass(btnsWrap[i].getElementsByTagName('a')[0], "selected")
  }
 $('geekPeople').style.display='none'; 
 $('searchPeople').style.display='none';
 $(activeSection).style.display='block';

 addClass($(btn), "selected");
 $(btn).blur();
}


function addClass(target, classValue)
{ //from the great book The Javascript Anthology
	var pattern = new RegExp("(^| )" + classValue + "( |$)");
	if (!pattern.test(target.className))
	{
		if (target.className == "")
		{
			target.className = classValue;
		}
		else
		{
			target.className += " " + classValue;
		}
	}
	return true;
}
function removeClass(target, classValue)
{ //from the great book The Javascript Anthology
	var removedClass = target.className;
	var pattern = new RegExp("(^| )" + classValue + "( |$)");
	removedClass = removedClass.replace(pattern, "$1");
	removedClass = removedClass.replace(/ $/, "");
	target.className = removedClass;
	return true;
}


// String Extensions... Yes, these are from Radiant! ;-)
Object.extend(String.prototype, {
  upcase: function() {
    return this.toUpperCase();
  },
  downcase: function() {
    return this.toLowerCase();
  },
  strip: function() {
    return this.replace(/^\s+/, '').replace(/\s+$/, '');
  },
  toInteger: function() {
    return parseInt(this);
  },
  toSlug: function() {
    // M@: Modified from Radiant's version, removes multple --'s next to each other
    // This is the same RegExp as the one on the page model...
    return this.strip().downcase().replace(/[^-a-z0-9~\s\.:;+=_]/g, '').replace(/[\s\.:;=_+]+/g, '-').replace(/[\-]{2,}/g, '-');
  }
});
