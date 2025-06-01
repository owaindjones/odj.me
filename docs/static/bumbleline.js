function _bumbleline(root, z, min_z, max_z, z_step, replace_color) {
	var step = z_step;
	var start_z = z;
	var childNodes = []
	for(var n=0; n<root.childNodes.length; n++) {
		childNodes.push(root.childNodes[n]);
	}
	for(var n=0; n<childNodes.length; n++) {
		var node = childNodes[n];
		if(['TITLE', 'SCRIPT', 'STYLE', 'IMG'].indexOf(node.nodeName) > -1) {
			continue;
		}
		if(['DIV', 'P', 'UL', 'LI'].indexOf(node.nodeName) > -1) {
			z = start_z;
			step = z_step;
		}
		if(node.nodeName != '#text') {
			ret = _bumbleline(node, z, min_z, max_z, step, replace_color);
			root.insertBefore(document.createTextNode(' '), node);
			z = ret[0];
			step = ret[1];
			continue;
		}
		var s = window.getComputedStyle(node.parentNode);
		if (s.color != replace_color) {
			continue;
		}
		var words = node.nodeValue.split(/(\s+)/);
		var text='';
		for(var w=0; w<words.length; w++) {
			var word = words[w];
			text += word;
			if(word.match(/\S+/) == null) {
				continue;
			}
			z += step;
			if (z >= max_z) {
				z = max_z;
				step = -step;
			}
			if (z <= min_z) {
				z = min_z;
				step = -step;
			}
			var elem = document.createElement('span');
			elem.innerHTML = text;
			elem.style.color = 'rgb(' + z + ', ' + z + ', ' + z + ')';
			root.insertBefore(elem, node);
			text = '';
		}
		root.insertBefore(document.createTextNode(''), node);
		root.removeChild(node);
	}
	return [z, step];
}

function bumbleline (root, z, min_z, max_z, z_step, replace_color) {
	root.originalHTML = root.cloneNode(true).innerHTML;
	root.swap = function () {
		if (root.classList.contains('beeline')) {
			root.innerHTML = root.originalHTML;
			root.classList.remove('beeline');
		} else {
			root.innerHTML = root.beelineHTML;
			root.classList.add('beeline');
		}
	};
	_bumbleline(root, z, min_z, max_z, z_step, replace_color);
	root.beelineHTML = root.cloneNode(true).innerHTML;
	root.classList.add('beeline');
}

function update_style () {
	var root = document.getElementById('article');
	var z_step = -4;
	var min_z = 160;
	var max_z = 240;
	var z = max_z;
	var replace_color_dark = 'rgb(204, 204, 204)';
	var replace_color_bright = 'rgb(102, 102, 102)';
	var replace_color = replace_color_dark;
	if(document.body.classList.contains('bright')) {
		z_step = 6;
		max_z = 122;
		min_z = 2;
		z = min_z;
		replace_color = replace_color_bright;
	}
	if(root.originalHTML) {
		root.innerHTML = root.originalHTML;
	}
	bumbleline(root, z, min_z, max_z, z_step, replace_color);
}

function toggle_bright_mode () {
	if(document.body.classList.contains('bright')) {
		document.body.classList.remove('bright');
	} else {
		document.body.classList.add('bright');
	}
	update_style();
}

document.addEventListener('DOMContentLoaded', function(event) {
	update_style();
});
