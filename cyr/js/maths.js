window.WebFontConfig = {
    custom: {
        families: ['KaTeX_AMS', 'KaTeX_Caligraphic:n4,n7', 'KaTeX_Fraktur:n4,n7',
                   'KaTeX_Main:n4,n7,i4,i7', 'KaTeX_Math:i4,i7', 'KaTeX_Script',
                   'KaTeX_SansSerif:n4,n7,i4', 'KaTeX_Size1', 'KaTeX_Size2', 'KaTeX_Size3',
                   'KaTeX_Size4', 'KaTeX_Typewriter'],
    },
};


$(document).ready(function () { // this need jquery
  renderMathInElement(document.body, {
    // ...options...
    delimiters: [
      { left: "$$", right: "$$", display: true },
      { left: "$", right: "$", display: false },
      { left: "\\[", right: "\\]", display: true }
    ]
  });
});

var element = document.getElementById('allcat');
document.addEventListener("DOMContentLoaded", function(){
    katex.render("\\forall x\\ldotp Cat(x) \\to Beautiful(x).",
                 element, {displayMode: true});
});

