
// I still hate css

import <LCSWrapperMenu.ash>;
buffer page;
boolean[string] all_pref_availability;

foreach x, it in preferences {
    all_pref_availability[it] = true;


    if(it.split_string("\\ \\|\\ ").count() >= 4){
        // Really weird workaround. "0".to_boolean() and "false".to_boolean() *should* return false, but it doesn't, so we have to use .contains_text() instead =/

        string execute = cli_execute_output(`ash {it.split_string("\\ \\|\\ ")[3]}`);
        all_pref_availability[it] = execute.contains_text('1') || execute.contains_text("true");

    }
}


void display_pref_as_selector(string preference){
    string [int] preference_details = split_string(preference, "\\ \\|\\ ");
    /* preference_details: 0 => Mafia pref, 1 => Description, 2 => Options, 3 => Conditional (maybe) */ 
    // [ Less than four options      ] OR [Options IS NOT ""            AND      Preference availability == true]

    // print(`{preference_details[0]} -------- {all_pref_availability[preference]}`, "orange");
    if(all_pref_availability[preference] == true){
        page.append('</tr>');
            page.append('<tr>');
                page.append(`<td>{preference_details[0]}</td>`);
                page.append(`<td>{preference_details[1]}</td>`);
                page.append('<td>');
                
                    string [int] choices = split_string(preference_details[2], "\\/");

                    if(choices.count() == 1){
                        page.append(`<input type="text" placeholder="" name="{preference_details[0]}" value="{entity_encode(get_property(preference_details[0]))}" />`);
                    } else { 

                        page.append(`<select name="{preference_details[0]}" value="{entity_encode(get_property(preference_details[0]))}" />`);  
                        for (int i = 0; i < min(choices.count(), 11); i++) {
                            if (choices[i] == get_property(preference_details[0])) {
                                page.append(`<option value="{choices[i]}" selected>{choices[i]}</option>`);
                            } else {
                                page.append(`<option value="{choices[i]}">{choices[i]}</option>`);
                            }
                        }

                    }
                    
        page.append('</select>');
  

    }

}

void display_experimental_prefs() {

    string[int] placeholder_text = {"Feeling Lost, Glowing Hands", "true", "Staff of the Roaring Hearth, Lens of Hatred", "false", "1", "mys, mox, mus, hp, hot res, non combat, item, fam weight, weapon damage, spell damage", "false", "false"};

    foreach value, preference in manual_preferences {
        string [int] preference_details = split_string(preference, "\\ \\|\\ ");
        page.append('</tr>');
        page.append('<tr>');
        page.append(`<td>{preference_details[0]}</td>`);
        page.append(`<td>{preference_details[1]}</td>`);
        page.append('<td>');
        page.append(`<input type="text" placeholder="{placeholder_text[value]}" name="{preference_details[0]}" value="{entity_encode(get_property(preference_details[0]))}" />`);        
        page.append('</select>');
    
    }
}

void main() {

string [string] post = form_fields();
    
if (post.count() > 1) {

// TODO green <style>
    write(`<b><center> Changed! </center></b>`);
    string final_preference;

    foreach pref, changed_pref in post{

        final_preference = post[pref];

        foreach x, it in preferences {
            string [int] preference_details = split_string(it, "\\ \\|\\ ");
            // Selection choice && pref == pref
            if(split_string(it, "\\ \\|\\ ")[2].split_string("\\/").count() > 1 && pref == preference_details[0]){
                // :upside_down:

                final_preference = changed_pref;
                break;
            }
        }

        if(final_preference != get_property(pref) && pref != "relay"){
            writeLn(`<p>Changed preference <b>{pref}</b> from <b>{get_property(pref)}</b> to <b>{final_preference}</b></p>`);
            set_property(pref, final_preference);
        }

    }
    
}
    

page.append('<title>LCSWrapper User Interface</title>');

// Style
page.append('<style>');

    page.append('body { font-family: `Verdana`, sans-serif;');
    page.append('background-color: #f4f4f4;');
    page.append('margin: 20px; }');


    page.append('form {');
        page.append('max-width: 800px;');
        page.append('margin: 0 auto;');
        page.append('background-color: #fff;');
        page.append('padding: 20px;');
        page.append('border-radius: 8px;');
        page.append('box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }');

    page.append('h1 {');
        page.append('text-align: center;');
        page.append('color: #333; }');

    page.append('p {');
        page.append('color: #555; }');


    page.append('table {');
        page.append('width: 100%;');
        page.append('border-collapse: collapse;');
        page.append('margin-top: 20px; }');


    page.append('th, td {');
        page.append('padding: 12px;');
        page.append('border: 1px solid #ddd;');
        page.append('text-align: left; }');


    page.append('th {');
        page.append('background-color: #f2f2f2; }');

    page.append('select {');
        page.append('width: 100%;');
        page.append('padding: 8px;');
        page.append('margin: 5px 0;');
        page.append('display: inline-block;');
        page.append('border: 1px solid #ccc;');
        page.append('box-sizing: border-box;');
        page.append('border-radius: 4px; }');


    page.append('input[type="submit"] {');
        page.append('background-color: #4caf50;');
        page.append('color: #fff;');
        page.append('padding: 10px 20px;');
        page.append('border: none;');
        page.append('border-radius: 4px;');
        page.append('cursor: pointer;');
        page.append('font-size: 16px; }');


    page.append('input[type="submit"]:hover {');
        page.append('background-color: #45a049; }');



    page.append('input[type="text"] {');
        page.append('width: 100%;');
        page.append('padding: 8px;');
        page.append('margin: 5px 0;');
        page.append('display: inline-block;');
        page.append('border: 1px solid #ccc;');
        page.append('box-sizing: border-box;');
        page.append('border-radius: 4px; }');

page.append('</style>');

// Body
page.append('</head> <body> <form action="" method="post"> ');
page.append('<h1>LCSWrapper User Interface</h1>');
page.append('<p><center>Graphical user interphase for setting LCSWrapper preferences =) </center></p>');

page.append('<table> <tr>');
    page.append('<th>Preference</th>');
    page.append('<th>Info</th>');
    page.append('<th>Selection</th>');

    foreach x, pref in preferences {
        display_pref_as_selector(pref);    
    }
page.append('</td> </tr> </table>');


page.append('<p><b><center>Experimental Settings:</center></p></b>');
page.append('<p><center>Greyed out placeholder text is an input example</center></p>');

    page.append('<table> <tr>');

    page.append('<th>Preference</th>');
    page.append('<th>Info</th>');
    page.append('<th>Selection</th>');

    
    display_experimental_prefs();    
    

page.append('</td> </tr> </table>');

page.append('<center><input type="submit" value="Save Changes"></center>');
page.append('</form> </body> </html>');


    write(page);
}
