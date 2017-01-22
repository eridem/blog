<div class="markdown-as-html"><h1>Loading markdown...</h1></div>

<script src="{{ site.baseurl }}/js/markdown-it.min.js"></script>

<script>
    var oReq = new XMLHttpRequest();
    oReq.onload = function (e) {
        var converter = window.markdownit();
        var text      = e.target.response;
        var html      = converter.render(text);
        var target = document.getElementsByClassName('markdown-as-html')[0];
        target.innerHTML = html;
        $("img").addClass("img-responsive").each(function() {
            var img = $(this);
            var src = img.attr('src');
            if (src.startsWith("/img/") || src.startsWith("img/")) {
                var newUrl = "{{ site.baseurl }}/" + src.replace(/^\//gi, '');;
                img.attr('src', newUrl);
            }
        })
    };
    oReq.open('GET', '{{ include.url }}', true);
    oReq.send();
</script>