'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var vertexai = require('@firebase/vertexai');



Object.keys(vertexai).forEach(function (k) {
	if (k !== 'default' && !exports.hasOwnProperty(k)) Object.defineProperty(exports, k, {
		enumerable: true,
		get: function () { return vertexai[k]; }
	});
});
//# sourceMappingURL=index.cjs.js.map
