/* 
    Client-Side Javascript code for velmex.html
    The idea is to make something somewhat similar to regex101.com, but for writing VXM commands.

    Try to use Darcula syntax coloring
    https://draculatheme.com/contribute

    
    https://stackoverflow.com/a/54687622
    https://prismjs.com/#basic-usage
*/

function codeColoring(text) {
    var code = new Array(
        { search: /\bF+\b/g, replace: '<span style="color:blue">F</span>' }, //Match F
        { search: /\bE+\b/g, replace: '<span style="color:blue">E</span>' }, //Match E
        { search: /\bC+\b/g, replace: '<span style="color:blue">C</span>' }, //Match C
        { search: /I[0-9]+M-[0-9]+/g, replace: '<span style="color:#f1fa8c">$1</span>' }, //Match
    );

    for (i = 0; i < code.length; i++) {
        text = text.replace(code[i].search, code[i].replace);
    }
    return text;
}


var textarea = document.getElementById("codearea");
textarea.addEventListener("input", function (e){
    console.log(textarea.value);
    var coderes = document.getElementById("coderesult");
    coderes.innerHTML = codeColoring(textarea.value);
});


