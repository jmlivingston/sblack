// <--- Sblack start --->
// First make sure the wrapper app is loaded
document.addEventListener("DOMContentLoaded", function() {

   // Then get its webviews
   let webviews = document.querySelectorAll(".TeamView webview");

   const customCustomCSS = `{{{CUSTOM_CSS}}}`

   // Insert a style tag into the wrapper view
   let s = document.createElement('style');
   s.type = 'text/css';
   s.innerHTML = customCustomCSS;
   document.head.appendChild(s);

   // Wait for each webview to load
   webviews.forEach(webview => {
      webview.addEventListener('ipc-message', message => {
         if (message.channel == 'didFinishLoading')
            // Finally add the CSS into the webview
            cssPromise.then(css => {
               let script = `
                     let s = document.createElement('style');
                     s.type = 'text/css';
                     s.id = 'slack-custom-css';
                     s.innerHTML = \`${customCustomCSS}\`;
                     document.head.appendChild(s);
                     `
               webview.executeJavaScript(script);
            })
      });
   });
});
// <--- Sblack end --->
