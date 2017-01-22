<div class="markdown-as-html"><h1>Loading markdown...</h1></div>

<script src="{{ site.url }}/{{ site.baseurl }}/js/markdown-it.min.js"></script>

<script>
    console.log('Loading external markdown 2...')
    var oReq = new XMLHttpRequest();
    oReq.onload = function (e) {
        var converter = window.markdownit();
        var text      = e.target.response;
        var html      = converter.render(text);
        var target = document.getElementsByClassName('markdown-as-html')[0];
        target.innerHTML = target.innerHTML.replace(/.*/gi, html);
    };
    oReq.open('GET', '{{ include.url }}', true);
    oReq.send();
</script>