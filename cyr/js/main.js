// cyrylyzujący kod


// callback naciśnięcia przycisku
function begin() {
    let inp = document.getElementById("input");
    // pobieram dane z pola tekstowego
    let output = document.getElementById("output");
    let submit = document.getElementById("submit");
    submit.onClick = (console.log(inp.value));
    // w paragraf outputowy wrzucam wynik funkcji cyrylize
    output.innerText = cyrylize(inp.value);
}

function cyrylize(string) {
    let rekey;
    let reval;

    re_dicts = dict.items
    
    for (keyval of re_dicts) {
        
        Object.entries(keyval).forEach(
            ([key, val]) => {
                for (var i = 0; i < 3; i++) {
                    rekey = new RegExp(key, 'g');
                    reval = new RegExp(val);
                    
                    string = string.replace(rekey, val);
                }
            }
        );
    }

    return string;
}
