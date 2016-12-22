var isProduction = process.env.NODE_ENV === 'production';
var min = '';
if (isProduction) {
	min = '.min';
}

module.exports = ({
	renderHtml: (body, state) =>
		`
			<!doctype html>
			<html>
				<head>
					<title>Tvrdim</title>
					<link rel="manifest" href="/manifest.json">
					<script>if (window.location.hash && window.location.hash == '#_=_') {
						if (window.history && history.pushState) {
							window.history.pushState("", document.title, window.location.pathname);
						} else {
							// Prevent scrolling by storing the page's current scroll offset
							var scroll = {
								top: document.body.scrollTop,
								left: document.body.scrollLeft
							};
							window.location.hash = '';
							// Restore the scroll offset, should be flicker free
							document.body.scrollTop = scroll.top;
							document.body.scrollLeft = scroll.left;
						}
					}</script>
					<script>window.__PRELOADED_STATE__ = ${JSON.stringify(state)}</script>
					<script src="https://cdnjs.cloudflare.com/ajax/libs/react/15.3.1/react${min}.js"></script>
					<script src="https://cdnjs.cloudflare.com/ajax/libs/react/15.3.1/react-dom${min}.js"></script>
					<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
				</head>
				<body>
					<div id="root">${body}</div>
					<script src="/bundle.js"></script>
				</body>
			</html>
		`
})
